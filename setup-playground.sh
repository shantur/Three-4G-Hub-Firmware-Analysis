#!/bin/bash

set -e

DUMPFILE=$1
FILE=`basename $DUMPFILE`

if [[ "$DUMPFILE" == "" ]]
then
    echo "Usage $0 <dumpfile>"
    exit
fi

echo Using nand dump from $1

mkdir -p playground
ubireader_extract_images -o playground $DUMPFILE
echo "UBI Images extracted to playground/$FILE"

mkdir -p playground/bootable-image-1
mkdir -p playground/bootable-image-2
mkdir -p playground/hackarea-image-2

echo "Extracting images needs sudo access"
sudo echo "Sudo access Granted"

echo Extracting playground/bootable-image-1 : Sercomm image

sudo unsquashfs -d playground/bootable-image-1 playground/$FILE/img-899062484_vol-ubi_vol_rootfs.ubifs

echo Extracting playground/bootable-image-2 : Three image

sudo unsquashfs -d playground/bootable-image-2 playground/$FILE/img-1603052933_vol-ubi_vol_rootfs.ubifs

echo Setting up HackArea with LD_PRELOAD capability for image-2

sudo unsquashfs -d playground/hackarea-image-2 playground/$FILE/img-1603052933_vol-ubi_vol_rootfs.ubifs

mkdir playground/downloads

echo
echo Downloading uClibc mips 0.9.30 system image
wget -O playground/downloads/system-image-mips.tar.bz2 https://www.uclibc.org/downloads/binaries/0.9.30.1/system-image-mips.tar.bz2

cd playground/downloads
tar -jxvf system-image-mips.tar.bz2
cd -
echo
echo Extracting sytem-image-mips

mkdir playground/downloads/system-image-mips/mnt
mkdir playground/downloads/system-image-mips/extracted
sudo losetup -P /dev/loop3 playground/downloads/system-image-mips/image-mips.ext2
sudo mount /dev/loop3 playground/downloads/system-image-mips/mnt
sudo cp -a playground/downloads/system-image-mips/mnt/* playground/downloads/system-image-mips/extracted/
sudo umount playground/downloads/system-image-mips/mnt
sudo losetup -D


echo
echo Copying libs from system-image-mips over to hackarea

sudo cp -a playground/downloads/system-image-mips/extracted/lib/* playground/hackarea-image-2/lib/


echo Disabling ramfs mounts

sudo chmod +w playground/bootable-image-1/etc/rcS
sudo sed -i 's/mount -n -t ramfs/#mount -n -t ramfs/g' playground/bootable-image-1/etc/rcS

sudo chmod +w playground/bootable-image-2/etc/rcS
sudo sed -i 's/mount -n -t ramfs/#mount -n -t ramfs/g' playground/bootable-image-2/etc/rcS