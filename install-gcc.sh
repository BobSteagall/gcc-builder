#!/bin/bash
##
##  Script: install-gcc.sh
##
##  This top-level script unzips the compressed tarball (TGZ) created
##  from the files installed into the staging directory and subsequently
##  zipped into a tarball in the "packages" subdirectory.
##
##- Make sure we're in the same directory as this script.
##
export TOP_DIR="$(cd "$(dirname "$0")" && pwd)"
cd $TOP_DIR

##- Get the GCC-related variables and command-line options for this build.
##
source ./gcc-build-vars.sh

##- Retrieve useful information about the platform.
##
PLATFORM_INFO=(`$TOP_DIR/system-type.sh -f`)
PLATFORM_OS=${PLATFORM_INFO[0]}
PLATFORM_NAME=${PLATFORM_INFO[1]}
PLATFORM_ARCH=${PLATFORM_INFO[4]}
PLATFORM_DESC=${PLATFORM_INFO[5]}

if [ "$PLATFORM_OS" = "FreeBSD" ] && [ "$PLATFORM_ARCH" = "amd64" ]; then
    PLATFORM_ARCH=x86_64
fi

PLATFORM_FULL="${PLATFORM_DESC}-${PLATFORM_ARCH}"
TARBALL=kewb-gcc${GCC_TAG}-${PLATFORM_FULL}.tgz

##- Unzip the tarball.
##
if [ -f ./packages/$TARBALL ]
then
    UZCMD="tar --no-overwrite-dir -xvf ./packages/$TARBALL"
    echo $UZCMD
    eval $UZCMD
else
    echo "error: KEWB GCC tarball not found"
fi
