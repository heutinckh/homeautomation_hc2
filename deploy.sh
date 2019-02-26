#!/bin/sh

#
# Deploy image to uSD card
#

# https://github.com/hardkernel/u-boot/tree/odroidxu3-v2012.07/sd_fuse/hardkernel_1mb_uboot

# From hardkernel info

# USD Image (eMMC image block -1)
# -------------------------------------------------------------------------------------------
#                    Offset                        |                     |       Size       |
# Block   Start-End (dec)       Start-End (hex)    | File/Contents       |  (dec)     (hex) | 
# -------------------------------------------------------------------------------------------
# 0       00000000 - 00000512   0x000000 - 0x000200  <empty>                  512    0x00200
# 1       00000512 - 00016128   0x000200 - 0x003F00  bl1.bin.hardkernel     15616    0x03D00
# !!!OVERLAP!!!
# 31      00015872 - 00030464   0x003E00 - 0x007700  bl2.bin.hardkernel     14592    0x03900
#
# 63      00032256 - 00630525   0x007E00 - 0x099EFD  u-boot-dtb.bin        598269    0x920FD
#
# 2111    01080832 - 01342976   0x107E00 - 0x147E00  tzsw.bin.hardkernel   262144    0x40000
# -------------------------------------------------------------------------------------------
# Partition 1: Rootfs
# 3000



# Parameters
DEVICE="$1" # /dev/<device> or IMG (to create a wic image ready for dd to uSD)
CWD=`pwd`
YOCTO_DIR="yocto-odroid"
IMG_DIR="${YOCTO_DIR}/build/tmp/deploy/images/*/"
RESOURCE_DIR="resources"
DEPLOY_DIR="deploy"

if [ "_${DEVICE}" = "_IMG" ]; then

    echo "Preparing SD Image"
    IMG_NAME="hh-image-odroid-xu4-hc2.sdimg"
    
    # Create placeholder
    mkdir -p ${DEPLOY_DIR}
    dd if=/dev/zero of=${DEPLOY_DIR}/${IMG_NAME} bs=512 count=3000

    # Add bootloaders
    UBOOT_FILE=`find ${IMG_DIR} -name u-boot-dtb.bin`
    dd if=${RESOURCE_DIR}/bl1.bin.hardkernel            of=${DEPLOY_DIR}/${IMG_NAME} iflag=dsync oflag=dsync seek=1 bs=512
    dd if=${RESOURCE_DIR}/bl2.bin.hardkernel.1mb_uboot  of=${DEPLOY_DIR}/${IMG_NAME} iflag=dsync oflag=dsync seek=31 bs=512
    dd if=${UBOOT_FILE}                                 of=${DEPLOY_DIR}/${IMG_NAME} iflag=dsync oflag=dsync seek=63 bs=512
    dd if=${RESOURCE_DIR}/tzsw.bin.hardkernel           of=${DEPLOY_DIR}/${IMG_NAME} iflag=dsync oflag=dsync seek=2111 bs=512

    # Add rootfs
    #ROOTFS_FILE=`find ${IMG_DIR} -name *xu4-hc2.ext4`
    #dd if=${ROOTFS_FILE} of=${DEPLOY_DIR}/${IMG_NAME} bs=1M iflag=fullblock oflag=direct conv=fsync status=progress

else

    # Checks
    echo "_${DEVICE}" | grep "/dev/mmcblk" 2>&1 >/dev/null
    if [ $? -ne 0 ]; then
        echo "ERROR: Invalid target device specified [${DEVICE}], please verify...."
        exit 1
    fi
fi

cd ${CWD}

