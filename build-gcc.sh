#!/bin/bash
##
##  Script: build-gcc.sh
##
##  This top-level script drives the overall process of compiling and testing
##  the GCC distribution.
##
##- Make sure we're in the same directory as this script.
##
export TOP_DIR="$(cd "$(dirname "$0")" && pwd)"
cd $TOP_DIR

./fetch-gcc.sh
./unpack-gcc.sh
./configure-gcc.sh
./make-gcc.sh
./test-as.sh
./test-g++.sh
./test-gcc.sh
