#!/bin/sh

#
# Deploy image to uSD card
#

# Parameters
DEVICE="$1"
CWD=`pwd`
YOCTO_DIR="yocto-odroid"
IMG_DIR="${YOCTO_DIR}/build/tmp/deploy/images/*/"
RESOURCE_DIR="resources"

# Checks
echo "_${DEVICE}" | grep "/dev/mmcblk" 2>&1 >/dev/null
if [ $? -ne 0 ]; then
    echo "ERROR: Invalid target device specified [${DEVICE}], please verify...."
    exit 1
fi

# Execution
INPUT_FILE=`find ${IMG_DIR} -name *.wic | grep -v rootfs`
dd if=${INPUT_FILE} of=${DEVICE} bs=1M iflag=fullblock oflag=direct conv=fsync status=progress

# Add bootloaders
INPUT_FILE=`find ${IMG_DIR} -name u-boot-dtb.bin`
dd if=${RESOURCE_DIR}/bl1.bin.hardkernel           of=${DEVICE} iflag=dsync oflag=dsync seek=1
dd if=${RESOURCE_DIR}/bl2.bin.hardkernel.1mb_uboot of=${DEVICE} iflag=dsync oflag=dsync seek=31
dd if=${INPUT_FILE}                                of=${DEVICE} iflag=dsync oflag=dsync seek=63
dd if=${RESOURCE_DIR}/tzsw.bin.hardkernel          of=${DEVICE} iflag=dsync oflag=dsync seek=2111

sudo sync
cd ${CWD}

