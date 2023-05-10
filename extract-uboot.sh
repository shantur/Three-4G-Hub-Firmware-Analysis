#!/bin/bash

src_image=$1

mkdir -p uboot

echo Extracting First u-boot image to uboot/uImage1
echo
dd if=$src_image of=uboot/uImage1 bs=1 skip=131072 count=102809
echo

echo uboot/uImage1 Details
echo
mkimage -l -T firmware uboot/uImage1
echo

echo Extracting compressed uBoot from uboot/uImage1 to uboot/uBoot1-lzma
echo
dumpimage -T firmware -o uboot/uBoot1-lzma uboot/uImage1
echo

echo Decompressing uBoot from uboot/uBoot1-lzma to uboot/uBoot1
lzcat uboot/uBoot1-lzma > uboot/uBoot1

echo Extracting strings from uboot/uBoot1 to uboot/uBoot1-strings.txt
echo
strings uboot/uBoot1 > uboot/uBoot1-strings.txt
echo

echo Extracting Second u-boot image to uboot/uImage2
echo
dd if=$src_image of=uboot/uImage2 bs=1 skip=262144 count=102809
echo

echo uboot/uImage2 Details
echo
mkimage -l -T firmware uboot/uImage2
echo

echo Extracting compressed uBoot from uboot/uImage2 to uboot/uBoot2-lzma
echo
dumpimage -T firmware -o uboot/uBoot2-lzma uboot/uImage2
echo

echo Decompressing uBoot from uboot/uBoot2-lzma to uboot/uBoot2
echo
lzcat uboot/uBoot2-lzma > uboot/uBoot2
echo

echo Extracting strings from uboot/uBoot2 to uboot/uBoot2-strings.txt
strings uboot/uBoot2 > uboot/uBoot2-strings.txt
echo

echo Extract uboot environment to uboot/uboot-environment.bin
dd if=$src_image of=uboot/uboot-environment.bin bs=1 skip=2097152 count=16384
echo

echo Extract strigs from uboot/uboot-environment.bin to uboot/uboot-environment-strings.txt
strings uboot/uboot-environment.bin > uboot/uboot-environment-strings.txt
echo

