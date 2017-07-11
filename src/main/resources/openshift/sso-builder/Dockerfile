FROM redhat-sso-7/sso70-openshift:latest

ADD import-realm.json /opt/eap/standalone/configuration/import-realm.json
ADD themes/rhamt /opt/eap/themes/rhamt/

RUN /opt/eap/bin/add-user-keycloak.sh --realm rhamt --user rhamt --password password --roles user
RUN /opt/eap/bin/add-user-keycloak.sh --realm master --user admin --password password
