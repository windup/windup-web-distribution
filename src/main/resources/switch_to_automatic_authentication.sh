#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR

./bin/jboss-cli.sh --file=unsecure-deployments.cli

echo "================================"
echo ""
echo "The system won't require an authentication step anymore."
echo ""
echo "================================"
