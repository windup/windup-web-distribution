#!/bin/bash

set -e

OCP_PROJECT=rhamt

DB_DATABASE=WindupServicesDS
DB_USERNAME=postgresuser
DB_PASSWORD=postgrespassword
APP=rhamt-web-console
APP_DIR=app
SERVICES_WAR=${APP_DIR}/api.war
UI_WAR=${APP_DIR}/rhamt-web.war

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${SCRIPT_DIR}

# Copy root war configuration
cp -R ../windup-web-redirect builder/

# Copy deployments
cp ../standalone/deployments/api.war ${SERVICES_WAR}
cp ../standalone/deployments/rhamt-web.war ${UI_WAR}

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
oc new-project ${OCP_PROJECT} > /dev/null
sleep 1
echo "  -> Switch to project"
oc project ${OCP_PROJECT} > /dev/null
sleep 1
echo "  -> Register service accounts"
oc policy add-role-to-user view system:serviceaccount:${OCP_PROJECT}:eap-service-account -n ${OCP_PROJECT}
oc policy add-role-to-user view system:serviceaccount:${OCP_PROJECT}:sso-service-account -n ${OCP_PROJECT}
sleep 1
echo "  -> Verify ImageStreams"
sleep 1
M=0
until [ ${M} -ge 50 ]
do
  EAP_IMG=$(oc describe is jboss-eap70-openshift -n openshift|grep latest|grep tagged|wc -l)
  SSO_IMG=$(oc describe is redhat-sso70-openshift -n openshift |grep latest|grep tagged|wc -l)
  if [ ${EAP_IMG} == "1" ]  && [ ${SSO_IMG} == "1" ]; then
    break
  else
    M=$[${M}+1]
    sleep 5
  fi
done

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
sleep 1
oc start-build --wait --from-dir=sso-builder rhamt-sso
sleep 1

echo "  -> Process SSO template"
# Template adapted from https://github.com/jboss-openshift/application-templates/blob/master/sso/sso70-postgresql-persistent.json
oc process -f templates/sso70-postgresql-persistent.json \
    -p SSO_ADMIN_USERNAME=admin \
    -p SSO_ADMIN_PASSWORD=admin \
    -p SSO_SERVICE_USERNAME=admin \
    -p SSO_SERVICE_PASSWORD=admin \
    -p SSO_REALM=rhamt \
    -p HTTPS_NAME=jboss \
    -p HTTPS_PASSWORD=mykeystorepass \
    -p POSTGRESQL_MAX_CONNECTIONS=200 \
    -p DB_DATABASE=${DB_DATABASE} \
    -p DB_USERNAME=${DB_USERNAME} \
    -p DB_PASSWORD=${DB_PASSWORD} \
    -p OCP_PROJECT=${OCP_PROJECT} | oc create -n ${OCP_PROJECT} -f -
sleep 1

SSO_HOSTNAME="$(oc get route --no-headers -o=custom-columns=HOST:.spec.host sso)"
echo "keycloak.server.url=http://${SSO_HOSTNAME}/auth" > app/configuration/eap.properties
#echo "     SSO URL: ${SSO_HOSTNAME}"

echo "  -> Process RHAMT template"
# Template adapted from https://github.com/jboss-openshift/application-templates/blob/master/eap/eap70-postgresql-persistent-s2i.json
oc process -f templates/rhamt-template.json \
    -p POSTGRESQL_MAX_CONNECTIONS=200 \
    -p DB_DATABASE=${DB_DATABASE} \
    -p DB_USERNAME=${DB_USERNAME} \
    -p DB_PASSWORD=${DB_PASSWORD} \
    -p OCP_PROJECT=${OCP_PROJECT} | oc create -n ${OCP_PROJECT} -f -

echo
echo "Build images"

echo "  -> Build 'eap-builder' image"
oc start-build --wait --from-dir=builder eap-builder

echo "  -> Build '${APP}' application image"
oc start-build --wait --from-dir=${APP_DIR} ${APP}

echo "  -> Deploy RHAMT Web Console ..."
N=0
until [ ${N} -ge 50 ]
do
  IS_RUNNING=$(oc get pods | grep rhamt-web-console | grep -v build | grep Running| wc -l)
  if [ ${IS_RUNNING} == "1" ]
  then
    break
  else
    N=$[${N}+1]
    sleep 5
  fi
done

CONSOLE_URL="http://$(oc get route --no-headers -o=custom-columns=HOST:.spec.host rhamt-web-console)/"

echo "Upload, build and deployment successful!"
echo
echo "Open ${CONSOLE_URL} to start using the RHAMT Web Console on OpenShift (user='rhamt',password='password')"
