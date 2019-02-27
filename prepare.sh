#!/bin/sh

# Prepare the build and deploy environment

set -e 

# Parameters
CWD=`pwd`
YOCTO_DIR="yocto-odroid"
TYPE="$1"

# Checks
if [ -d ${YOCTO_DIR} ]; then
    echo "Error: Existing directory: ${YOCTO_DIR} found, please remove first..."
    exit 1
fi

#
# Stand alone image based fully on external sources
#
if [ "_${TYPE}" = "_STANDALONE" ]; then
    git clone git://git.yoctoproject.org/poky ${YOCTO_DIR}
    cd ${YOCTO_DIR}
    git clone git://git.openembedded.org/openembedded-core
    git clone https://github.com/akuster/meta-odroid.git
    mv meta old-meta
    mv meta-openembedded/ meta
    source oe-init-build-env
    bitbake add-layer ../meta-odroid/
    echo "MACHINE = \"odroid-xu4\"" >> conf/local.conf 

elif [ "_${TYPE}" = "_XU4_HC2" ]; then
    YOCTO_FLAVOUR="thud"
    PATCH_FILE=`pwd`/resources/0001-odroid-xu4-hc2-linux-support-workaround.patch

    git clone -b ${YOCTO_FLAVOUR} git://git.yoctoproject.org/poky.git ${YOCTO_DIR}
    cd ${YOCTO_DIR}
    git clone -b ${YOCTO_FLAVOUR} git://github.com/akuster/meta-odroid
    cp -r layers/meta-hh ${YOCTO_DIR}/.
    
    # Apply work around patches
    (cd meta-odroid; patch -p0 < ${PATCH_FILE})
    
    # Move to version supporting odroid c2 (workaround for nice branch/tag
    (cd meta-odroid; git checkout 688ff9c5f549f072af204ee64d5ad3ee18b9e47f)
    
    . ./oe-*
    bitbake-layers add-layer ../meta-odroid
    bitbake-layers add-layer ../meta-hh
    echo "MACHINE = \"odroid-xu4-hc2\"" >> conf/local.conf 

else
    echo ""
    echo " Please provide a valid target: "
    echo "  - STANDALONE      A standalone build based on meta-odroid from akuster"
    echo "  - XU4_HC2         A custom image specifically for the XU4-HC2" 
    echo ""
    exit 1
fi

cd ${CWD}

echo "---------------------------------"
echo "      Preparation Finished       "
echo "---------------------------------"
