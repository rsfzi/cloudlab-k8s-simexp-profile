#!/bin/sh

set -x

# Grab our libs
BINDIR=`dirname $0`
. "$BINDIR/setup-lib.sh"

if [ -f $OURDIR/custom_os-done ]; then
    exit 0
fi

DPKGOPTS=''
APTGETINSTALLOPTS='-y'

if [ -z "$EUID" ]; then
    EUID=`id -u`
fi
SUDO=
if [ ! $EUID -eq 0 ] ; then
    SUDO=sudo
fi

logtstart "custom_os"

$SUDO apt-get $DPKGOPTS install $APTGETINSTALLOPTS fish ncdu
$SUDO chsh -s /usr/bin/fish $SWAPPER

logtend "custom_os"
touch $OURDIR/custom_os-done
