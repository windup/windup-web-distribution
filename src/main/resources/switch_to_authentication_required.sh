#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR

./bin/jboss-cli.sh --file=unsecure-deployments.cli
./bin/jboss-cli.sh --file=secure-deployments.cli

echo "================================"
echo ""
echo "The system will now require an authentication step."
echo ""
echo "We recommend that you verify the ENV Variables SSO_AUTH_SERVER_URL, SSO_REALM, SSO_SSL_REQUIRED, and SSO_CLIENT_ID".
echo ""
echo "================================"
