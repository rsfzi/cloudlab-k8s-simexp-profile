#!/bin/bash

set -x

# Grab our libs
export SRC=`dirname $0`
cd $SRC
. $SRC/setup-lib.sh

if [ -f $OURDIR/kubernetes-custom-worker-done ]; then
    exit 0
fi

logtstart "kubernetes-custom-worker"

echo "increase inotify max_user_instances to 8192"
$SUDO sysctl -w fs.inotify.max_user_instances=8192
echo 'fs.inotify.max_user_instances = 8192' | $SUDO tee -a /etc/sysctl.conf

logtend "kubernetes-custom-worker"
touch $OURDIR/kubernetes-custom-worker-done
exit 0
