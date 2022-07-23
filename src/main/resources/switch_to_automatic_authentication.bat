@echo off

set "DIR=%~dp0"

cd "%DIR%"

$DIR/bin/jboss-cli.bat --file=switch_to_automatic_authentication.cli

echo "================================"
echo ""
echo "The system won't require an authentication step anymore."
echo ""
echo "================================"
