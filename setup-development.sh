#!/bin/bash

# Grab our libs
. "`dirname $0`/setup-lib.sh"

if [ -f $OURDIR/development-done ]; then
    exit 0
fi

logtstart "development"

DEV_DIR=$STORAGEDIR/$SWAPPER

$SUDO mkdir -p $DEV_DIR
status=$?
if [ $status -ne 0 ]; then
    echo "Error: mkdir failed to create $DEV_DIR (exit code $status)" >&2
    exit 1
fi
$SUDO chown $SWAPPER:$SWAPPER $DEV_DIR
status=$?
if [ $status -ne 0 ]; then
    echo "Error: chown failed (exit code $status)" >&2
    exit 1
fi
cd $HOME
ln -s $DEV_DIR develop
status=$?
if [ $status -ne 0 ]; then
    echo "Error: ln failed (exit code $status)" >&2
    exit 1
fi

logtend "development"
touch $OURDIR/development-done
