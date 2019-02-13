#!/bin/sh

# Prepare the build and deploy environment

set -e 

# Parameters
CWD=`pwd`
YOCTO_FLAVOUR="thud"
YOCTO_DIR="yocto-odroid"

# Checks
if [ -d ${YOCTO_DIR} ]; then
    echo "Error: Existing directory: ${YOCTO_DIR} found, please remove first..."
    exit 1
fi

# Do Work
git clone -b ${YOCTO_FLAVOUR} git://git.yoctoproject.org/poky.git ${YOCTO_DIR}
cd ${YOCTO_DIR}
git clone -b ${YOCTO_FLAVOUR} git://github.com/akuster/meta-odroid
cp -r layers/meta-hh ${YOCTO_DIR}/.

# Move to version supporting odroid c2 (workaround for nice branch/tag
(cd meta-odroid; git checkout 688ff9c5f549f072af204ee64d5ad3ee18b9e47f)

. ./oe-*
bitbake-layers add-layer ../meta-odroid
bitbake-layers add-layer ../meta-hh
echo "MACHINE = \"odroid-xu4-hc2\"" >> conf/local.conf 

cd ${CWD}

echo "---------------------------------"
echo "      Preparation Finished       "
echo "---------------------------------"
