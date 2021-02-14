#!/bin/bash
sudo losetup -D
sudo losetup -P /dev/loop0 sdcard.img 
sudo mount /dev/loop0p1 /mnt

