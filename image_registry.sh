#!/bin/bash

export SRC=`dirname $0`
. "$BINDIR/setup-lib.sh"

if [ -f $OURDIR/image-registry-done ]; then
    exit 0
fi

logtstart "image-registry"


kubectl apply -f $SRC/image-registry.yaml
status=$?
if [ $status -ne 0 ]; then
    echo "Error: kubectl for image-registry failed (exit code $status)" >&2
    exit 1
fi

# Wait for pod
while kubectl get pods -A -l app=registry | awk 'split($3, a, "/") && a[1] != a[2] { print $0; }' | grep -v "RESTARTS"; do
    echo 'Waiting for image-registry to be ready...'
    sleep 5
  done
  echo 'image-registry is ready.'

echo 'login to image-registry'
# https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/
podman login -u u -p p node-0:30500 --tls-verify=false
status=$?
if [ $status -ne 0 ]; then
    echo "Error: podman login failed (exit code $status)" >&2
    exit 1
fi

kubectl create secret generic cred-simexp-registry --from-file=.dockerconfigjson=$XDG_RUNTIME_DIR/containers/auth.json --type=kubernetes.io/dockerconfigjson
status=$?
if [ $status -ne 0 ]; then
    echo "Error: kubectl create secret failed (exit code $status)" >&2
    exit 1
fi
#cat $XDG_RUNTIME_DIR/containers/auth.json
podman logout node-0:30500
echo "image registry prepared"

logtend "image-registry"
touch $OURDIR/image-registry-done
exit 0
