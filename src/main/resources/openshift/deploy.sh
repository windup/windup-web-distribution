#!/bin/bash

set -e

PROPERTIES_FILE=${1:-deployment.properties}

if [ ! -f ${PROPERTIES_FILE} ]; then
    echo "Configuration file ${PROPERTIES_FILE} does not exist";
    exit 1;
fi

while IFS='=' read -r key value
do
    key=$(echo ${key} | tr '.' '_')

    if [ -z ${!key} ]; then
        eval "${key}='${value}'"
    fi

done < ${PROPERTIES_FILE}

required_variables=(
    'OCP_PROJECT'
    'DB_VOLUME_CAPACITY'
    'RHAMT_VOLUME_CAPACITY'
    'WEB_CONSOLE_REQUESTED_CPU'
    'WEB_CONSOLE_REQUESTED_MEMORY'
    'EXECUTOR_REQUESTED_CPU'
    'EXECUTOR_REQUESTED_MEMORY'
    'DB_DATABASE'
    'DB_USERNAME'
    'DB_PASSWORD'
    'SSO_PUBLIC_KEY'
    'DOCKER_IMAGES_USER'
    'DOCKER_IMAGES_TAG'
)

for var in "${required_variables[@]}"
do
    if [ -z ${!var} ]; then
        echo "Required variable '${var}' not set";
        exit 2;
    fi
done


echo
echo "Openshift project"
echo "  -> Create Openshift project (${OCP_PROJECT})"
oc new-project ${OCP_PROJECT} > /dev/null
sleep 1
echo "  -> Switch to project"
oc project ${OCP_PROJECT} > /dev/null
sleep 1
#echo "  -> Register service accounts"
#oc policy add-role-to-user view system:serviceaccount:${OCP_PROJECT}:eap-service-account -n ${OCP_PROJECT}
#oc policy add-role-to-user view system:serviceaccount:${OCP_PROJECT}:sso-service-account -n ${OCP_PROJECT}
#sleep 1


echo "  -> Process RHAMT Web Template"
# Template adapted from https://github.com/jboss-openshift/application-templates/blob/master/sso/sso70-postgresql-persistent.json
oc process -f templates/web-template-empty-dir-executor.json \
    -p SSO_REALM=rhamt \
    -p POSTGRESQL_MAX_CONNECTIONS=200 \
    -p DB_DATABASE=${DB_DATABASE} \
    -p DB_USERNAME=${DB_USERNAME} \
    -p DB_PASSWORD=${DB_PASSWORD} \
    -p VOLUME_CAPACITY=${DB_VOLUME_CAPACITY} \
    -p RHAMT_VOLUME_CAPACITY=${RHAMT_VOLUME_CAPACITY} \
    -p WEB_CONSOLE_REQUESTED_CPU=${WEB_CONSOLE_REQUESTED_CPU} \
    -p WEB_CONSOLE_REQUESTED_MEMORY=${WEB_CONSOLE_REQUESTED_MEMORY} \
    -p EXECUTOR_REQUESTED_CPU=${EXECUTOR_REQUESTED_CPU} \
    -p EXECUTOR_REQUESTED_MEMORY=${EXECUTOR_REQUESTED_MEMORY} \
    -p DOCKER_IMAGES_USER=${DOCKER_IMAGES_USER} \
    -p DOCKER_IMAGES_TAG=${DOCKER_IMAGES_TAG} | oc create -n ${OCP_PROJECT} -f -
sleep 1

echo -n "  -> Deploy RHAMT Web Console ..."
N=0
until [ ${N} -ge 50 ]
do
  IS_RUNNING=$(oc get pods | grep rhamt-web-console | grep -v build |  grep -v deploy | grep Running | grep -v '0/'|wc -l)
  if [ ${IS_RUNNING} == "1" ]
  then
    echo -e "done"
    #echo -e "\e[92m[OK]\e[39m"
    break
  else
    N=$[${N}+1]
    echo -n "."
    sleep 5
  fi
done
if [ ${N} -eq 50 ]
    then
        #echo -e "\e[91m[KO]\e[39m"
	echo
	echo "Check the status of the project in the OpenShift console to see if it is still processing or if there are errors"
    else
	CONSOLE_URL="http://$(oc get route --no-headers -o=custom-columns=HOST:.spec.host rhamt-web-console)/"

	echo "Upload, build and deployment successful!"
	echo
	echo "Open ${CONSOLE_URL} to start using the RHAMT Web Console on OpenShift (user='rhamt',password='password')"
fi
