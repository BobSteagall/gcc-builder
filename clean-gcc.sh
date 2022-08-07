#!/bin/bash
##
##  Script: clean-gcc.sh
##
##  This top-level script removes all output of the build, letting the user
##  start from scratch.
##
##- Make sure we're in the same directory as this script.
##
export TOP_DIR="$(cd "$(dirname "$0")" && pwd)"
cd $TOP_DIR

##- Get the GCC-related variables for this build.
##
source ./gcc-build-vars.sh

rm -rf ./custom_fixes_done
rm -rf ./dist
rm -rf ./packages
rm -rf $BU_SRC_DIR
rm -rf $BU_BLD_DIR
rm -rf $GCC_SRC_DIR
rm -rf $GCC_BLD_DIR
