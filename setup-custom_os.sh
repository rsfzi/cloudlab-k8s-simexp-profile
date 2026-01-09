#!/bin/sh

set -x

# Grab our libs
BINDIR=`dirname $0`
. "$BINDIR/setup-lib.sh"

if [ -f $OURDIR/custom_os-done ]; then
    exit 0
fi

DPKGOPTS=''
APTGETINSTALLOPTS='-y --no-install-recommends'

if [ -z "$EUID" ]; then
    EUID=`id -u`
fi
SUDO=
if [ ! $EUID -eq 0 ] ; then
    SUDO=sudo
fi

logtstart "custom_os"

$SUDO apt-get $DPKGOPTS install $APTGETINSTALLOPTS vim fish ncdu htop bat
$SUDO apt-get $DPKGOPTS install $APTGETINSTALLOPTS podman uidmap
$SUDO chsh -s /usr/bin/fish $SWAPPER

PODMAN_FOLDER=/storage/podman/$SWAPPER
$SUDO mkdir -p $PODMAN_FOLDER
$SUDO chown rsfzi $PODMAN_FOLDER

mkdir -p /users/rsfzi/$SWAPPER/.local/share
cd /users/rsfzi/$SWAPPER/.local/share
ln -s $PODMAN_FOLDER containers

logtend "custom_os"
touch $OURDIR/custom_os-done
