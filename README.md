# Three 4G+ Hub - Sercomm LTE2122GR Firmware analysis

## Requirements
The analysis was done on Kali Linux 2023.01

DO NOT RUN boot-image.sh on your host machine only in VM.

The following dependencies were installed
```
sudo apt install u-boot-tools
sudo pip install jefferson
sudo pip install ubi_reader
```

and below tools ( list is incomplete )

- Unsquashfs
- Qemu-user-static

Might be more.


## Quick summary

Three 4G+ Hub is manufactured by Sercomm. The nanddump was taken by @dazmatic over ISPreview forums after 
removing the nand flash and reading with USB Programmer.

Nand dump is 256MB in size and has multiple blocks / partitions.

Binwalk is used to determine the partitions and extracted with ubi_reader, dd and jefferson

As of now, the main discoveries are:

1. There are 2 bootable u-boot partitions but use the same uboot-environment in the nand.
1. There are 2 UBI partitions each with a kernel and rootfs. These are extracted as image-1 and image-2
1. Image-1 is Sercomm branded web portal and other is 3 branded. Both have diferent firmware versions.
1. Apart from these there are few partitons that get mounted over `/mnt/{0, 1, 2}` and some config partitons. 
1. `/mnt/2/.p` = Private key file gerenated to perform encryption at rest.
1. `/mnt/2/` also contains serial number probably read from hardware and cached. There were few more interesting files.
1. Public key is used to encrypt private key and its hard coded in libsex_crypt.so. A strings command reveals the hard coded key.
1. `/etc/default.xml` is the main configuration the drives the router. It controls evrything - users, services, firewall etc. This can be decrypted with xmltool.
1. All the encryption is handled by `libsex_crypt.so`
1. `cmld` seems to be configuration management daemon that reads `default.xml` and manages merging with settings updated by user.
1. TR-069 is enabled and allows 3 to send automatic firmware updates and run commands.
1. `sc_cli` is a command line utility to manage router. Run with `sc_cli -m "" -h "" -p ""`.

## Attacks

# Serial console

Serial port was discovered on J2 marked pads just above the RJ45 phone socket. Its is disabled by default most probably in the PreBoot loader stage. There is no output on serial after a few lines of DRAM messages

<details>
<summary> Default Serial Log </summary>
```
    II: LDO setup...
    II: DRAM init...
    3120010407fc00001ef2ea239802d0f0000fff003e81f4258c8800000708000007022200200f000fc53c22808037f20a1a93c351808037020a1443c302808033e20a1553c303808033e20a155101a50110004120010130000001f01f101f01f201f01f301f01f401f01f501f01f601d01f701f01f801f01b901f01da01f01db01f01bc01f01bd01f01be01f01bf01f01d1001f01f1101f01f1201f01f1301f01f1401f01f1501f01f1601f01f1701d01f1801f01b1901f01d1a01f01d1b01f01d1c01f01b1d01f01b1e01f01b1f01f01d21320000a022581770098644828808051f6516000
```
</details>


But when reset button is held it does print few more things

More details here https://www.ispreview.co.uk/talk/threads/three-4g-hub-sercomm-lte2122gr-modding-discussions.39724/

## Sercomm Recovery tool

There is a Sercomm Recovery tool that can talk to router in Download / recovery mode here : https://github.com/danitool/sercomm-recovery
Attempts were made to use sercomm-recovery tool but couldn't get it to work

## Configuration crafting

TBC

## Firmware package

TBC


# Play steps

## Setup

## Should only be run in a VM

1. Download the nand dump from ISPreview forum here https://www.ispreview.co.uk/talk/threads/three-4g-hub-sercomm-lte2122gr-modding-discussions.39724/post-305833
1. Clone this repository
1. Run `./install-deps.sh` to install dependencies
1. Run `./setup-playground <Path to DumpFile>`. This will setup all in `playground` folder
1. Run `./boot-image.sh image-1` to boot the first image.
1. Check the notes printed on the shell and follow them
1. Have fun with the image in browser.
1. When done, press Ctrl + D on prompt to exit.
1. Run `./shutdown-images.sh` to stop all processes and mounts.

# Tools

Run `./build-tools.sh`

## XMLTool - Decrypt / Encrypt default.xml

TBC

