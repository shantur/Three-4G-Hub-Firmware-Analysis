#!/bin/bash

set -e

echo Downloading cross-compiler-mips
echo
wget -O playground/downloads/cross-compiler-mips.tar.bz2 https://www.uclibc.org/downloads/binaries/0.9.30.1/cross-compiler-mips.tar.bz2

echo Extracting cross-compilter-mips
cd playground/downloads/
tar -jxvf cross-compiler-mips.tar.bz2
cd -

sudo cp playground/downloads/cross-compiler-mips/lib/* playground/hackarea-image-2/lib/

mkdir -p playground/tools

PWD=`pwd`

echo Running in $PWD

echo
echo Building xmltool

PATH=$PWD/playground/downloads/cross-compiler-mips/bin:$PATH mips-gcc -fPIE \
    -L$PWD/playground/hackarea-image-2/lib \
    -lsex_crypt -lmd5 -lz -lcfg -lcrypto -lutility -lslog -lcal -lhcal \
    -lcml_api -lcrypt -lsalx -lnv \
    -Wl,--warn-unresolved-symbols -o $PWD/playground/tools/xmltool ./xmltool.c

echo
echo Copying xmltool to all images

sudo cp $PWD/playground/tools/xmltool playground/bootable-image-2/
sudo cp $PWD/playground/tools/xmltool playground/bootable-image-1/
sudo cp $PWD/playground/tools/xmltool playground/hackarea-image-2/
