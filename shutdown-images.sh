#!/bin/bash

echo Running cleanup

ps -ax | sed 's/  */ /g' | grep qemu | cut -d ' ' -f 1 | xargs -I %s sudo kill -9 %s
sleep 1
ps -ax | sed 's/  */ /g' | grep qemu | cut -d ' ' -f 1 | xargs -I %s sudo kill -9 %s

mount | grep "playground/bootable" | cut -d ' ' -f 3 | xargs -I %s sudo umount %s 
sleep 1
mount | grep "playground/bootable" | cut -d ' ' -f 3 | xargs -I %s sudo umount %s 

sudo rm -rf playground/bootable-$IMAGE/tmp/ht*
