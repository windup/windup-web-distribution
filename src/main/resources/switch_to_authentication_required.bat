@echo off

set "DIR=%~dp0"

cd "%DIR%"

./bin/jboss-cli.bat --file=switch_to_automatic_authentication.cli
./bin/jboss-cli.bat --file=switch_to_authentication_required.cli

echo "================================"
echo ""
echo "The system will now require an authentication step."
echo ""
echo "We recommend that you verify the ENV Variables SSO_AUTH_SERVER_URL, SSO_REALM, SSO_REALM_PUBLIC_KEY, SSO_SSL_REQUIRED, and SSO_CLIENT_ID".
echo ""
echo "================================"
