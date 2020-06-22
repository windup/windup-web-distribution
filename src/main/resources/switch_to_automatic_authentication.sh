#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR

cp $DIR/themes/mta/login/auto_login.theme.properties $DIR/themes/mta/login/theme.properties

echo "================================"
echo ""
echo "The system won't require an authentication step anymore."
echo ""
echo "If you previously removed guest user, login to http://localhost:8080/auth and add user 'mta' with password 'password' to the MTA realm".
echo "(Default Keycloak user: admin, password: password)"
echo ""
echo "================================"
