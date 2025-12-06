#!/bin/bash

set -x

SUDO=
if [ ! $EUID -eq 0 ] ; then
    SUDO=sudo
fi

mkdir -p $HOME/develop/palladio/runtime-SimExp
mkdir -p $HOME/develop/palladio/simexp-ea
mkdir -p $HOME/develop/kubernetes

BRANCH=-b ma_bruening-ea-integration
cd $HOME/develop/palladio/simexp-ea
git clone $BRANCH git@github.com:PalladioSimulator/Palladio-Analyzer-SimExp
cd $HOME/develop/kubernetes
git clone $BRANCH git@github.com:rsfzi/Simexp-Kubernetes-Worker.git

BRANCH=-b ma_bruening-ea-integration_strategy-fix
git clone $BRANCH git@github.com:PalladioSimulator/Palladio-Addons-EnvironmentalDynamics


cd $HOME/develop/palladio/runtime-SimExp
ln -s ../simexp-ea/Palladio-Addons-EnvironmentalDynamics/examples/org.palladiosimulator.envdyn.examples.deltaiot

cd $HOME/develop/kubernetes/Simexp-Kubernetes-Worker
ln -s /users/rsfzi/develop/palladio/simexp-ea/Palladio-Analyzer-SimExp/products/org.palladiosimulator.simexp.product.console/target/products/org.palladiosimulator.simexp.product.console-linux.gtk.x86_64.zip
