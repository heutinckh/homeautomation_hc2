#!/bin/sh

# Generate a deployable uSD image

CWD=`pwd`
YOCTO_DIR="yocto-odroid"

cd ${YOCTO_DIR}
. ./oe-*

bitbake core-image-minimal

cd ${CWD}
