#!/bin/bash

set -x

# Grab our libs
export SRC=`dirname $0`
cd $SRC
. $SRC/setup-lib.sh

if [ -f $OURDIR/kubernetes-custom-done ]; then
    exit 0
fi

logtstart "kubernetes-custom"


$SUDO apt install --no-install-recommends skopeo
# skopeo --tls-verify=false inspect docker://node-0:5000/simexp_console

#echo "Taint data nodes..."
#echo "Taint data node: node-1"
#kubectl taint nodes node-1 datanode=true:NoExecute --overwrite=true

echo "Taint worker nodes..."
NON_WORKER_COUNT=2
read -r -a arr <<< "$NODES"
for node in "${arr[@]: -${NON_WORKER_COUNT}}"; do
    echo "Taint worker node: $node"
    kubectl taint nodes $node remote=true:NoExecute --overwrite=true
done

echo "Creating rabbitmq service and statefulset..."
kubectl apply -f $SRC/rabbitmq-namespace.yaml
status=$?
if [ $status -ne 0 ]; then
    echo "Error: kubectl for rabbitmq-namespace failed (exit code $status)" >&2
    exit 1
fi
kubectl apply -f $SRC/rabbitmq-service.yaml
status=$?
if [ $status -ne 0 ]; then
    echo "Error: kubectl for rabbitmq-service failed (exit code $status)" >&2
    exit 1
fi
kubectl apply -f $SRC/vagrant/rabbitmq-statefulset.yaml
status=$?
if [ $status -ne 0 ]; then
    echo "Error: kubectl for rabbitmq-statefulset failed (exit code $status)" >&2
    exit 1
fi

logtend "kubernetes-custom"
touch $OURDIR/kubernetes-custom-done
exit 0
