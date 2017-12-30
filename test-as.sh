#!/bin/bash
##
##  Script: test-as.sh
##
##  This top-level script tests the GNU assembler
##
##- Make sure we're in the same directory as this script.
##
export TOP_DIR="$(cd "$(dirname "$0")" && pwd)"
cd $TOP_DIR

##- Get the GCC-related variables and command-line options for this build.
##
source ./gcc-build-vars.sh

if [ -e $BU_BLD_DIR ]
then
    ##- Run the GCC tests
    ##
    cd $BU_BLD_DIR
    $GCC_MAKE $GCC_TEST_JOBS_ARG check-gas
fi
