#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR

$DIR/bin/jboss-cli.sh --file=switch_to_automatic_authentication.cli

echo "================================"
echo ""
echo "The system won't require an authentication step anymore."
echo ""
echo "================================"
