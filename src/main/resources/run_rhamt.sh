#!/bin/bash


## Increase the open file limit if low, to what we need or at least to the hard limit.
## Complain if the hard limit is lower than what we need.
WE_NEED=1024
MAX_HARD=$(ulimit -H -n);
MAX_SOFT=$(ulimit -S -n);

# ulimit command produces non-integer output 'unlimited' on Mac OS X v10.11
if [ $MAX_HARD == "unlimited" ] ; then
    let "MAX_HARD = $WE_NEED + 1"
fi

if [ $MAX_SOFT -lt $WE_NEED ] ; then 

  if [ $MAX_HARD -lt $WE_NEED ] ; then 
    echo "The limit for number of open files is too low ($MAX_HARD), which may make RHAMT unstable."
    echo "Please consider increasing the limit to at least $WE_NEED, see your system's documentation."
    echo "For Linux, limits are typically configured in /etc/security/limits.conf .";
    echo "For Mac OS X, limits are typically configured in /etc/launchd.conf or /etc/sysctl.conf (guide here: https://gist.github.com/Maarc/d13b1e70f191d5b527a24d39dd3e2569) .";
  fi
  MIN_WE_NEED_OR_CAN_HAVE=$(( $MAX_HARD > $WE_NEED ? $WE_NEED : $MAX_HARD ))
  echo "Increasing the maximum of open files to $MIN_WE_NEED_OR_CAN_HAVE."
  ulimit -S -n $MIN_WE_NEED_OR_CAN_HAVE
fi


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export JBOSS_HOME=$DIR

if [ -z "$WINDUP_DATA_DIR" ] ; then
    export WINDUP_DATA_DIR=$DIR/standalone/data
fi

$DIR/bin/standalone.sh -c standalone-full.xml -Dwindup.data.dir=$WINDUP_DATA_DIR $@
