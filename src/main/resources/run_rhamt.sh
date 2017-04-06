#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export JBOSS_HOME=$DIR

if [ -z "$WINDUP_DATA_DIR" ] ; then
    export WINDUP_DATA_DIR=$DIR/standalone/data
fi

$DIR/bin/standalone.sh -c standalone-full.xml -Dwindup.data.dir=$WINDUP_DATA_DIR
