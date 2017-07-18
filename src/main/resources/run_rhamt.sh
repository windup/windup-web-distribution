#!/bin/bash


## Complain about file descriptors limit if low.
WE_NEED=1024
MAX_OPEN_FILES=$(ulimit -H -n);
MAX_WE_NEED_OR_CAN_HAVE=$(( $WE_NEED < $MAX_OPEN_FILES ? $WE_NEED : $MAX_OPEN_FILES ))

if [ $MAX_OPEN_FILES -lt $WE_NEED ] ; then 
    echo "The limit for number of open files is too low ($MAX_OPEN_FILES), which may make RHAMT unstable."
    echo "Please consider increasing the limit to at least $WE_NEED, see your system's documentation."
    echo "For Linux, limits are typically configured in /etc/security/limits.conf .";
    echo "For Mac OS X, limits are typically configured in /etc/launchd.conf or /etc/sysctl.conf .";
fi
echo "Setting maximum of open files to $MAX_WE_NEED_OR_CAN_HAVE."
ulimit -S -n $MAX_WE_NEED_OR_CAN_HAVE


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export JBOSS_HOME=$DIR

if [ -z "$WINDUP_DATA_DIR" ] ; then
    export WINDUP_DATA_DIR=$DIR/standalone/data
fi

$DIR/bin/standalone.sh -c standalone-full.xml -Dwindup.data.dir=$WINDUP_DATA_DIR $@
