#!/bin/bash
##
##  Script: test-gcc.sh
##
##  This top-level script tests the GCC C compiler (gcc).
##
##- Make sure we're in the same directory as this script.
##
export TOP_DIR="$(cd "$(dirname "$0")" && pwd)"
cd $TOP_DIR

##- Get the GCC-related variables and command-line options for this build.
##
source ./gcc-build-vars.sh

##- Run the GCC tests
##
cd $GCC_BLD_DIR/gcc
$GCC_MAKE $GCC_TEST_THREADS_ARG check-gcc
