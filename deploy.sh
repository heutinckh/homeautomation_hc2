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
#INPUT_FILE=`find ${IMG_DIR} -name *.wic | grep -v rootfs`
#dd if=${INPUT_FILE} of=${DEVICE} bs=1M iflag=fullblock oflag=direct conv=fsync status=progress

# Add bootloaders
INPUT_FILE=`find ${IMG_DIR} -name u-boot-dtb.bin`
dd if=${RESOURCE_DIR}/bl1.bin.hardkernel           of=${DEVICE} iflag=dsync oflag=dsync seek=1
dd if=${RESOURCE_DIR}/bl2.bin.hardkernel.1mb_uboot of=${DEVICE} iflag=dsync oflag=dsync seek=31
dd if=${INPUT_FILE}                                of=${DEVICE} iflag=dsync oflag=dsync seek=63
dd if=${RESOURCE_DIR}/tzsw.bin.hardkernel          of=${DEVICE} iflag=dsync oflag=dsync seek=2111

sudo sync
cd ${CWD}

