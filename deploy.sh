#!/bin/sh

#
# Deploy image to uSD card
#

# https://github.com/hardkernel/u-boot/tree/odroidxu3-v2012.07/sd_fuse/hardkernel_1mb_uboot

# ----------------------------------------------------
# Offset Start-End  File/Contents                    Size (byes)
# 0x000000 - 0x00200   MBR                             0x00200
# 0x000200 - 0x03F00!! bl1.bin.hardkernel              0x03D00
# 0x003E00 - 0x07700   bl2.bin.hardkernel.1mb_uboot    0x03900
#        
# 0x007E00 - 0x09dA20  u-boot-dtb.bin                  0x95C20
# 0x107E00 - 0x147E00  tzsw.bin.hardkernel             0x40000
#




# Parameters
DEVICE="$1" # /dev/<device> or IMG (to create a wic image ready for dd to uSD)
CWD=`pwd`
YOCTO_DIR="yocto-odroid"
IMG_DIR="${YOCTO_DIR}/build/tmp/deploy/images/*/"
RESOURCE_DIR="resources"
DEPLOY_DIR="deploy"

if [ "_${DEVICE}" = "_IMG" ]; then

    IMG_NAME="hh-image-odroid-xu4-hc2.wic"
    echo "Preparing wic image"
    mkdir -p ${DEPLOY_DIR}
    cp yocto-odroid/build/tmp/deploy/images/odroid-xu4-hc2/core-image-minimal-odroid-xu4-hc2.wic ${DEPLOY_DIR}/${IMG_NAME}

    # Add bootloaders

    INPUT_FILE=`find ${IMG_DIR} -name u-boot-dtb.bin`
    dd if=${RESOURCE_DIR}/bl1.bin.hardkernel           of=${DEPLOY_DIR}/${IMG_NAME} iflag=dsync oflag=dsync seek=1
    dd if=${RESOURCE_DIR}/bl2.bin.hardkernel.1mb_uboot of=${DEPLOY_DIR}/${IMG_NAME} iflag=dsync oflag=dsync seek=31
    dd if=${INPUT_FILE}                                of=${DEPLOY_DIR}/${IMG_NAME} iflag=dsync oflag=dsync seek=63
    dd if=${RESOURCE_DIR}/tzsw.bin.hardkernel          of=${DEPLOY_DIR}/${IMG_NAME} iflag=dsync oflag=dsync seek=2111

    sudo sync

    # Execution
    #INPUT_FILE=`find ${IMG_DIR} -name *.wic | grep -v rootfs`
    #dd if=${INPUT_FILE} of=${DEVICE} bs=1M iflag=fullblock oflag=direct conv=fsync status=progress

else

    # Checks
    echo "_${DEVICE}" | grep "/dev/mmcblk" 2>&1 >/dev/null
    if [ $? -ne 0 ]; then
        echo "ERROR: Invalid target device specified [${DEVICE}], please verify...."
        exit 1
    fi
fi

cd ${CWD}

