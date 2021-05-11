#!/bin/bash
##
##  Script: gcc-build-vars.sh
##
##  This script sets configuration and build variables that are used by
##  all the other scripts.  It is intended to be called by other scripts.
##  It assumes that TOP_DIR has been defined appropriately by the caller,
##  and that it is being sourced by the calling script.
##
##- Customize this variable to specify the version of GCC 9 that you want
##  to download and build.
##
export GCC_VERSION=11.1.0

##- Customize variable this to name the installation; the custom name is
##  displayed when a user invokes gcc/g++ with the -v or --version flags.
##
export GCC_PKG_NAME='KEWB Computing Build'

##- Customize this variable to define the middle substring of the GCC build
##  triple.
##
export GCC_CUSTOM_BUILD_STR=kewb

##- Customize this variable to specify where this version of GCC will be
##  installed.
##
export GCC_INSTALL_PREFIX=/opt/$GCC_VERSION

##- Customize this variable to specify where the scripts that set various
##  important environment variables for using this version of GCC will be
##	installed.
##
export GCC_INSTALL_SCRIPTS_PREFIX=/usr/local/bin

##- Customize this variable to specify the installation's time stamp.
##
export GCC_TIME_STAMP=20210511094900

##- Customize these variables if you want to change the arguments passed
##  to make that specify the number of jobs/processes used to build and
##  test GCC, respectively.
##
export GCC_BUILD_JOBS_ARG='-j16'
export GCC_TEST_JOBS_ARG='-j8'

##- Set this variable to YES if you want to embed the assember and linker
##  from a custom version of GNU Binutils (specified below) into the GCC
##  installation.  If you just want to use the system's assembler and linker,
##  then undefine this variable or set its value to "NO".
##
export GCC_USE_CUSTOM_BINUTILS=NO

##------------------------------------------------------------------------------
##      Maybe change below this line, if you have a good reason.
##------------------------------------------------------------------------------
##
##- Customize this variable if you want the gcc/g++ executables to be
##  built with a suffix in their names (e.g., gccfoo/g++foo). In general,
##  this is best left undefined.
##
export GCC_EXE_SUFFIX=

##- These variables define the versions of binutils, GMP, MPC, and MPFR
##  used to build GCC.
##
export BU_VERSION=2.32
export GMP_VERSION=6.1.2
export MPC_VERSION=1.1.0
export MPFR_VERSION=3.1.6

##------------------------------------------------------------------------------
##      Do not change below this line!
##------------------------------------------------------------------------------
##
export GCC_PLATFORM=`uname`

export GCC_TARBALL=gcc-$GCC_VERSION.tar.xz
export GMP_TARBALL=gmp-$GMP_VERSION.tar.xz
export MPC_TARBALL=mpc-$MPC_VERSION.tar.gz
export MPFR_TARBALL=mpfr-$MPFR_VERSION.tar.xz

if [ "$GCC_PLATFORM" == "Linux" ] && [ "$GCC_USE_CUSTOM_BINUTILS" == "YES" ]
then
    export BU_TARBALL=binutils-$BU_VERSION.tar.xz
    export BU_SRC_DIR=$TOP_DIR/binutils-$BU_VERSION
    export BU_BLD_DIR=$TOP_DIR/binutils-$BU_VERSION-build
fi

export ALL_TARBALLS="$GCC_TARBALL $GMP_TARBALL $MPC_TARBALL $MPFR_TARBALL $BU_TARBALL"

export GCC_TAG="${GCC_VERSION//.}"
export GCC_SRC_DIR=$TOP_DIR/gcc-$GCC_VERSION
export GCC_BLD_DIR=$TOP_DIR/gcc-$GCC_VERSION-build
export GCC_INSTALL_RELDIR=`echo $GCC_INSTALL_PREFIX | sed 's:^/::'`
export GCC_INSTALL_SCRIPTS_RELDIR=`echo $GCC_INSTALL_SCRIPTS_PREFIX | sed 's:^/::'`
export GCC_MAJOR_VERSION=`echo $GCC_VERSION | cut -d '.' -f 1`

export GCC_STAGEDIR=$TOP_DIR/dist

if [ "$GCC_PLATFORM" == "FreeBSD" ]
then
    export GCC_MAKE=gmake

elif [ "$GCC_PLATFORM" == "Linux" ]
then
    export GCC_MAKE=make
else
    echo "Unknown build platform!"
    exit 1
fi

if [ -z "$NO_PARSE_OPTS" ]
then
    if [ $# == "0" ]
    then
        export DO_TEST=YES
    else
        while getopts ":tT" opt
        do
            case $opt in
                h ) echo "usage: $0 [-h] [-t|-T]"
                    exit 1 ;;
                t ) export DO_TEST=YES ;;
                T ) export DO_TEST= ;;
                * ) echo "usage: $0 [-h] [-t|-T]"
                    exit 1 ;;
            esac
        done
    fi
fi

