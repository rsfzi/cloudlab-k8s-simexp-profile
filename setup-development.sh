#!/bin/bash

# Grab our libs
. "`dirname $0`/setup-lib.sh"

if [ -f $OURDIR/development-done ]; then
    exit 0
fi

logtstart "development"

maybe_install_packages podman

SWAPPER_GROUP=$(id -gn "$SWAPPER")
BASE_DIR=$STORAGEDIR/$SWAPPER
DEV_DIR=$BASE_DIR/develop
MVN_DIR=$BASE_DIR/m2
CONTAINER_DIR=$BASE_DIR/container

$SUDO mkdir -p $BASE_DIR
status=$?
if [ $status -ne 0 ]; then
    echo "Error: mkdir failed to create $BASE_DIR (exit code $status)" >&2
    exit 1
fi
$SUDO chown $SWAPPER:$SWAPPER_GROUP $BASE_DIR
status=$?
if [ $status -ne 0 ]; then
    echo "Error: chown failed (exit code $status)" >&2
    exit 1
fi

mkdir -p $DEV_DIR
status=$?
if [ $status -ne 0 ]; then
    echo "Error: mkdir failed to create $DEV_DIR (exit code $status)" >&2
    exit 1
fi
cd $HOME
ln -s $DEV_DIR develop
status=$?
if [ $status -ne 0 ]; then
    echo "Error: ln for develop failed (exit code $status)" >&2
    exit 1
fi

mkdir -p $MVN_DIR
status=$?
if [ $status -ne 0 ]; then
    echo "Error: mkdir failed to create $MVN_DIR (exit code $status)" >&2
    exit 1
fi
cd $HOME
ln -s $MVN_DIR .m2
status=$?
if [ $status -ne 0 ]; then
    echo "Error: ln for .m2 failed (exit code $status)" >&2
    exit 1
fi

mkdir -p $CONTAINER_DIR
status=$?
if [ $status -ne 0 ]; then
    echo "Error: mkdir failed to create $CONTAINER_DIR (exit code $status)" >&2
    exit 1
fi
cd $HOME
mkdir -p .local/share
cd .local/share
ln -s $CONTAINER_DIR containers
status=$?
if [ $status -ne 0 ]; then
    echo "Error: ln for containers failed (exit code $status)" >&2
    exit 1
fi

logtend "development"
touch $OURDIR/development-done
