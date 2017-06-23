#!/bin/bash

OCP_PROJECT=rhamt

APP=rhamt-web-console
APP_DIR=app
SERVICES_WAR=${APP_DIR}/api.war
UI_WAR=${APP_DIR}/rhamt-web.war

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR

# Copy root war configuration
cp -R ../windup-web-redirect builder/

# Copy deployments
cp ../standalone/deployments/api.war $SERVICES_WAR
cp ../standalone/deployments/rhamt-web.war $UI_WAR

# Copy SSO Themes
rm -rf sso-builder/themes
mkdir -p sso-builder/themes/
cp -R ../themes/rhamt sso-builder/themes/
cp sso-builder/themes/rhamt/login/login_required.theme.properties sso-builder/themes/rhamt/login/theme.properties



# Checks if the "api.war" file has been added properly
ls -al ${SERVICES_WAR}
rc=$?; if [[ $rc != 0 ]]; then echo "Missing deployment. Please build and copy api.war to to ${SERVICES_WAR}"; exit $rc; fi

# Checks if the "rhamt-web.war" file has been added properly
ls -al ${UI_WAR}
rc=$?; if [[ $rc != 0 ]]; then echo "Missing deployment. Please build and copy rhamt-web.war to to ${UI_WAR}"; exit $rc; fi

echo
echo "Openshift project"
echo "  -> Create Openshift project (${OCP_PROJECT})"
oc new-project ${OCP_PROJECT} 2>/dev/null > /dev/null
sleep 1

echo "  -> Switch to project"
oc project ${OCP_PROJECT}  2>&1 > /dev/null

echo
echo "Project setup"

# Templates taken from https://github.com/jboss-openshift/application-templates/tree/master/secrets
echo "  -> Populate EAP and SSO secrets"
oc create -n ${OCP_PROJECT} -f templates/eap-app-secret.json
sleep 1
oc create -n ${OCP_PROJECT} -f templates/sso-app-secret.json
sleep 1

echo "  -> Build 'sso-builder' image"
oc process -f templates/rhamt-sso-image.json | oc create -n ${OCP_PROJECT} -f -

oc start-build --wait --from-dir=sso-builder rhamt-sso

HTTPS_NAME="jboss"
HTTPS_PASSWORD="mykeystorepass"
echo "  -> Process SSO template"
# Template adapted from https://github.com/jboss-openshift/application-templates/blob/master/sso/sso71-postgresql-persistent.json
oc process -f templates/sso70-postgresql-persistent.json \
    -p SSO_ADMIN_USERNAME=admin \
    -p SSO_ADMIN_PASSWORD=admin \
    -p SSO_SERVICE_USERNAME=admin \
    -p SSO_SERVICE_PASSWORD=admin \
    -p SSO_REALM=rhamt \
    -p HTTPS_NAME=${HTTPS_NAME} \
    -p HTTPS_PASSWORD=${HTTPS_PASSWORD} \
    -p OCP_PROJECT=${OCP_PROJECT} | oc create -n ${OCP_PROJECT} -f -

echo "    -> Waiting on SSO startup (90 seconds)..."
sleep 90

SSO_HOSTNAME=`oc get route --no-headers -o=custom-columns=HOST:.spec.host secure-sso`
SSO_URL="https://$SSO_HOSTNAME/auth"

echo "  -> SSO URL: $SSO_URL"
cp app/configuration/eap.cli.original app/configuration/eap.cli
sed -i -e "s#KEYCLOAK_URL#$SSO_URL#g" app/configuration/eap.cli
sed -i -e "s#HTTPS_NAME#$HTTPS_NAME#g" app/configuration/eap.cli
sed -i -e "s#HTTPS_PASSWORD#$HTTPS_PASSWORD#g" app/configuration/eap.cli

echo "  -> Process RHAMT template"
# Template adapted from https://github.com/jboss-openshift/application-templates/blob/master/eap/eap70-postgresql-persistent-s2i.json
oc process -f templates/rhamt-template.json \
    -p POSTGRESQL_MAX_CONNECTIONS=200 \
    -p HTTPS_NAME=${HTTPS_NAME} \
    -p HTTPS_PASSWORD=${HTTPS_PASSWORD} | oc create -n ${OCP_PROJECT} -f -

echo
echo "Build images"

echo "  -> Build 'eap-builder' image"
oc start-build --wait --from-dir=builder eap-builder

echo "  -> Build '${APP}' application image"
oc start-build --wait --from-dir=${APP_DIR} ${APP} 2>/dev/null > /dev/null

echo "  -> Applications built -- pause for the system to settle"
sleep 30

echo
echo "Start application (${APP})"

oc new-app -e JAVA_HOME=/usr/lib/jvm/java-1.8.0 ${APP}  2>/dev/null > /dev/null
