FROM redhat-sso-7/sso70-openshift:1.3

ADD import-realm.json /opt/eap/standalone/configuration/import-realm.json
ADD themes/rhamt /opt/eap/themes/rhamt/

RUN /opt/eap/bin/add-user-keycloak.sh --realm rhamt --user rhamt --password password --roles user


