#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR

echo "---> Processing switch_to_authentication_required.cli.template configuration file..."
envsubst '${SSO_AUTH_SERVER_URL} ${SSO_REALM} ${SSO_REALM_PUBLIC_KEY} ${SSO_SSL_REQUIRED} ${SSO_CLIENT_ID}' < ./switch_to_authentication_required.cli.template > ./switch_to_authentication_required.cli

$DIR/bin/jboss-cli.sh --file=switch_to_automatic_authentication.cli
$DIR/bin/jboss-cli.sh --file=switch_to_authentication_required.cli

echo "================================"
echo ""
echo "The system will now require an authentication step."
echo ""
echo "We recommend that you verify the ENV Variables SSO_AUTH_SERVER_URL, SSO_REALM, SSO_REALM_PUBLIC_KEY, SSO_SSL_REQUIRED, and SSO_CLIENT_ID".
echo ""
echo "================================"
