@echo off

set "DIR=%~dp0"

cd "%DIR%"

./bin/jboss-cli.bat --file=unsecure-deployments.cli

echo "================================"
echo ""
echo "The system won't require an authentication step anymore."
echo ""
echo "================================"
