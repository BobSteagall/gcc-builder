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

if [ "$GCC_PLATFORM" == "Linux" ]
then
    if [ ! -e $GMP_TARBALL ]
    then
        echo "Downloading $GMP_TARBALL... "
        wget http://ftpmirror.gnu.org/gmp/$GMP_TARBALL
    fi

    if [ ! -e $MPC_TARBALL ]
    then
        echo "Downloading $MPC_TARBALL... "
        wget http://ftpmirror.gnu.org/mpc/$MPC_TARBALL
    fi

    if [ ! -e $MPFR_TARBALL ]
    then
        echo "Downloading $MPFR_TARBALL... "
        wget http://ftpmirror.gnu.org/mpfr/$MPFR_TARBALL
    fi
fi

if [ "$GCC_PLATFORM" == "Linux" ] && [ "$GCC_USE_NEWER_BINUTILS" == "YES" ]
then
    if [ ! -e $BU_TARBALL ]
    then
        echo "Downloading $BU_TARBALL... "
        wget http://ftpmirror.gnu.org/binutils/$BU_TARBALL
    fi
fi

if [ ! -e $GCC_TARBALL ]
then
    echo "Downloading $GCC_TARBALL... "
    wget http://ftpmirror.gnu.org/gcc/gcc-$GCC_VERSION/$GCC_TARBALL
fi
