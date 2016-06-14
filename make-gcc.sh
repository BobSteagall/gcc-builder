#!/bin/bash
##
##  Script: make-gcc.sh
##
##  This second-level script compiles GCC and any supporting sources.
##
##- Make sure we're in the same directory as this script.
##
export TOP_DIR="$(cd "$(dirname "$0")" && pwd)"
cd $TOP_DIR

##- Get the GCC-related variables for this build.
##
source ./gcc-build-vars.sh

##- Make gcc itself.
##
cd $GCC_BLD_DIR
$GCC_MAKE $GCC_BUILD_THREADS_ARG

##- Make binutils on Linux.
##
if [ "$GCC_PLATFORM" == "Linux" ] && [ "$GCC_USE_NEWER_BINUTILS" == "YES" ]
then
    cd $BU_BLD_DIR
    $GCC_MAKE
    echo ""
    echo ""
    echo "======================================================================"
    echo "======================================================================"
    echo "======================================================================"
    echo ""
    echo ""
fi
