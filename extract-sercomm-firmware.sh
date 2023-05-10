#!/bin/bash

src_file=$1

Extracting SerComm-Download-Mode.bin
dd if=$src_file of=SerComm-Downlad-Mode.bin bs=1 skip=524288 count=85872
echo

Extracting SerComm-Firmware-Signature.bin
dd if=$src_file of=SerComm-Firmware-Signature.bin bs=1 skip=655290 count=29440
