#!/bin/bash

set -e

IMAGE=$1

if [[ "$IMAGE" == "" ]]
then
    echo "Usage $0 <image-name>"
    echo "Example - $0 image-1"
    exit
fi

QEMU_MIPS=`which qemu-mips-static`

sudo rm -rf playground/bootable-$IMAGE/tmp/*
sudo mkdir playground/bootable-$IMAGE/tmp/var

echo "Running qemu-mips-static in usermode"
sudo cp $QEMU_MIPS playground/bootable-$IMAGE/

echo =======================================
echo Run etc/rcS in the command prompt below
echo when the logs stop open http://localhost
echo in browser on your virtual machine.
echo
echo Login details
echo User : superuser
echo Pass : 3UK-lte2122gr
echo
echo User : admin
echo Pass : 1234567890abcde
echo
echo When you are done press Ctrl + D to exit
echo and run ./shutdown-images.sh to cleanup
echo =======================================

sudo chroot playground/bootable-$IMAGE/ /qemu-mips-static -E LD_LIBRARY_PATH=/lib /bin/sh
