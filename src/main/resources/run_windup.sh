#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z "$WINDUP_DATA_DIR" ] ; then
    export WINDUP_DATA_DIR=$DIR/standalone/data
fi

if [ "$WINDUP_DATA_DIR" != "$DIR/standalone/data" ] ; then
    export JAVA_OPTS="-Dwindup.data.dir=$WINDUP_DATA_DIR"
    $DIR/bin/jboss-cli.sh --file=update-windup-datasource.cli
fi

$DIR/bin/standalone.sh -c standalone-full.xml

