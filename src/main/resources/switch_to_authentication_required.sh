#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR

cp $DIR/themes/${product-name}/login/login_required.theme.properties $DIR/themes/${product-name}/login/theme.properties

echo "================================"
echo ""
echo "The system will now require an authentication step."
echo ""
echo "We recommend that you login to http://localhost:8080/auth and remove the default 'migration' user from the realm at this point".
echo "(Default Keycloak user: admin, password: password)"
echo ""
echo "================================"
