#!/bin/bash

set -x

# Grab our libs
. "`dirname $0`/setup-lib.sh"

if [ -f $OURDIR/kubernetes-custom-done ]; then
    exit 0
fi

logtstart "kubernetes-custom"


$SUDO apt install --no-install-recommends skopeo

logtend "kubernetes-custom"
touch $OURDIR/kubernetes-custom-done
exit 0
