#!/bin/bash
##
##  Script: fetch-gcc.sh
##
##  This second-level script downloads the GCC sources, as well as any other
##  sources needed to build GCC.
##
##- Make sure we're in the same directory as this script.
##
export TOP_DIR="$(cd "$(dirname "$0")" && pwd)"
cd $TOP_DIR

##- Get the GCC-related variables for this build.
##
source ./gcc-build-vars.sh

mkdir -p ./tarballs
cd ./tarballs

echo "Checking for required tarballs... "

fetch_file() {
    local REMOTE_URL=$1
    local TARBALL=$2

    if [ ! -e $TARBALL ]
    then
        echo "Downloading $TARBALL... "
        wget -t 3 $REMOTE_URL/$TARBALL

        if [ $? -ne 0 ]; then
            echo "Error retrieving $TARBALL... verify the URL and file name...  exiting"
            exit -1
        fi
    else
        echo "Already have $TARBALL"
    fi
}

if [ "$GCC_PLATFORM" == "Linux" ]
then
    fetch_file  http://ftp.gnu.org/gnu/gmp   $GMP_TARBALL
    fetch_file  http://ftp.gnu.org/gnu/mpc   $MPC_TARBALL
    fetch_file  http://ftp.gnu.org/gnu/mpfr  $MPFR_TARBALL
fi

if [ "$GCC_PLATFORM" == "Linux" ] && [ "$GCC_USE_CUSTOM_BINUTILS" == "YES" ]
then
    fetch_file  http://ftp.gnu.org/gnu/binutils  $BU_TARBALL
fi

fetch_file  http://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION  $GCC_TARBALL
