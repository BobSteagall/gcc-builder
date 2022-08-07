#!/bin/bash
##
##  Script: configure-gcc.sh
##
##  This second-level script configures GCC, and anything else that is
##  needed to build it.
##
##- Make sure we're in the same directory as this script.
##
export TOP_DIR="$(cd "$(dirname "$0")" && pwd)"
cd $TOP_DIR

##- Get the GCC-related variables for this build.
##
source ./gcc-build-vars.sh

##- Run the GCC configure script using our customizations.
##
cd $GCC_BLD_DIR
echo -n "Checking for configuration log in $GCC_BLD_DIR..."

if [ ! -e config.log ]
then
    echo ""
    echo "Running configure from $GCC_SRC_DIR... "

    if [ "$GCC_PLATFORM" == "FreeBSD" ]
    then
        $GCC_SRC_DIR/configure -v               \
            --with-pkgversion="$GCC_PKG_NAME"   \
            --prefix=$GCC_INSTALL_PREFIX        \
            --program-suffix=$GCC_EXE_SUFFIX    \
            --enable-tls                        \
            --enable-shared                     \
            --enable-threads=posix              \
            --enable-languages=c,c++            \
            --enable-lto                        \
            --enable-bootstrap                  \
            --disable-nls                       \
            --disable-multilib                  \
            --disable-install-libiberty         \
            --with-system-zlib                  \
            --with-gmp=/usr/local               \
            --with-mpfr=/usr/local              \
            --with-mpc=/usr/local

    elif [ "$GCC_PLATFORM" == "Linux" ]
    then
        $GCC_SRC_DIR/configure -v               \
            --with-pkgversion="$GCC_PKG_NAME"   \
            --prefix=$GCC_INSTALL_PREFIX        \
            --program-suffix=$GCC_EXE_SUFFIX    \
            --enable-bootstrap                  \
            --enable-__cxa_atexit               \
            --enable-cet                        \
            --enable-clocale=gnu                \
            --enable-gnu-indirect-function      \
            --enable-gnu-unique-object          \
            --enable-initfini-array             \
            --enable-languages=c,c++            \
            --enable-linker-build-id            \
            --enable-lto                        \
            --enable-offload-targets=nvptx-none \
            --enable-plugin                     \
            --enable-shared                     \
            --enable-threads=posix              \
            --enable-tls                        \
            --disable-install-libiberty         \
            --disable-libmpx                    \
            --disable-libunwind-exceptions      \
            --disable-multilib                  \
            --disable-nls                       \
            --disable-werror                    \
            $GCC_PBS_CONFIG_OPTION              \
            --with-linker-hash-style=gnu        \
            --with-system-zlib                  \
            --with-tune=generic                 \
            --without-cuda-driver 
    fi

    echo "GCC configuration completed!"
    echo ""
else
    echo " found"
    echo "GCC configure has already been run"
fi

##- Run the binutils configure script.
##
if [ "$GCC_PLATFORM" == "Linux" ] && [ "$GCC_USE_CUSTOM_BINUTILS" == "YES" ]
then
    cd $BU_BLD_DIR
    echo -n "Checking for configuration log in $BU_BLD_DIR..."

    if [ ! -e config.log ]
    then
        echo ""
        echo "Running configure from $BU_SRC_DIR... "

        $BU_SRC_DIR/configure -v

        echo "binutils configuration completed!"
        echo ""
    else
        echo " found"
        echo "Configure has already been run for binutils"
    fi
fi
