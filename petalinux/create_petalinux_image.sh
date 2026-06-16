#!/bin/bash

PRJ_NAME="blink"

LAST_BIN="$(realpath $(ls -td -- ../bin/*/ | head -n 1))"
XSA_FILE="$(find $LAST_BIN/*.xsa)"
BIT_FILE="$(find $LAST_BIN/*.bit)"

IMG_FOLDER="$(realpath ./$PRJ_NAME/images/linux)"

echo "Creating petalinux project: $PRJ_NAME"
echo "BIN folder: $LAST_BIN"

if [ ! -d $PRJ_NAME ]; then #if folder doesnt exist, create project
    petalinux-create project -n $PRJ_NAME --template zynq
fi

(cd $PRJ_NAME; petalinux-config --get-hw-description=$XSA_FILE)

(cd $PRJ_NAME; petalinux-build)

(cd $PRJ_NAME; petalinux-config -c kernel)

(cd $PRJ_NAME; petalinux-package boot --force --fsbl $IMG_FOLDER/zynq_fsbl.elf --u-boot $IMG_FOLDER/u-boot.elf --fpga $BIT_FILE)

(cd $PRJ_NAME; petalinux-package wic)
