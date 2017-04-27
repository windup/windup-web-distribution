@echo off

set "DIR=%~dp0"

cd "%DIR%"

copy "%DIR%\themes\rhamt\login\auto_login.theme.properties" "%DIR%\themes\rhamt\login\theme.properties"

echo "================================"
echo ""
echo "The system won't require an authentication step anymore."
echo ""
echo "If you previously removed guest user, login to http://localhost:8080/auth and add user 'rhamt' with password 'password' to the RHAMT realm".
echo "(Default Keycloak user: admin, password: password)"
echo ""
echo "================================"
