#!/bin/bash

set -x

# Grab our libs
. "`dirname $0`/setup-lib.sh"

if [ -f $OURDIR/kubernetes-custom-done ]; then
    exit 0
fi

logtstart "kubernetes-custom"


$SUDO apt install --no-install-recommends skopeo
# skopeo --tls-verify=false inspect docker://node-0:5000/simexp_console

logtend "kubernetes-custom"
touch $OURDIR/kubernetes-custom-done
exit 0
