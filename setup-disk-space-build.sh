#!/bin/bash

##
## Setup extra space.  We prefer the LVM route, using all available PVs
## to create a big VG.  If that's not available, we fall back to
## mkextrafs.pl to create whatever it can in /storage.
##

set -x

if [ -z "$EUID" ]; then
    EUID=`id -u`
fi

# Grab our libs
. "`dirname $0`/setup-lib.sh"

if [ -f $OURDIR/disk-space-build-done ]; then
    exit 0
fi

logtstart "disk-space-build"

if [ -f $SETTINGS ]; then
    . $SETTINGS
fi
if [ -f $LOCALSETTINGS ]; then
    . $LOCALSETTINGS
fi

VGNAME="emulab"
ARCH=`uname -m`

maybe_install_packages lvm2 maybe_install_packages thin-provisioning-tools

#
# First try to make LVM volumes; fall back to mkextrafs.pl /storage.  We
# use /storage later, so we make the dir either way.
#
$SUDO mkdir -p ${STORAGEDIR}
echo "STORAGEDIR=${STORAGEDIR}" >> $LOCALSETTINGS

output=$($SUDO lvs --noheadings --options lv_name,vg_name --separator ' ' 2>/dev/null)
status=$?
if [ $status -ne 0 ]; then
    echo "Error: 'lvs' command failed (exit code $status)" >&2
    exit 1
fi

output=$(echo "$output" | awk 'NF')   # remove empty lines
if [ -z "$output" ]; then
    echo "Error: 'lvs' returned no logical volumes." >&2
    exit 2
fi

read LVNAME VGNAME <<< "$output"
if [ -z "$LVNAME" ] || [ -z "$VGNAME" ]; then
    echo "Error: Failed to parse LV and VG names." >&2
    exit 3
fi

echo "found LV: $VGNAME / $LVNAME"

$SUDO mkfs.ext4 /dev/$VGNAME/$LVNAME
echo "/dev/$VGNAME/$LVNAME ${STORAGEDIR} ext4 defaults 0 0" \
    | $SUDO tee -a /etc/fstab
$SUDO mount ${STORAGEDIR}

logtend "disk-space-build"
touch $OURDIR/disk-space-build-done
