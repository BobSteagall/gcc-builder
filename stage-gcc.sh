#!/bin/bash
##
##  Script: stage-gcc.sh
##
##  This top-level script installs the new GCC build into a staging location
##  suitable for building a distribution tarball and/or RPM.
##
##- Make sure we're in the same directory as this script.
##
export TOP_DIR="$(cd "$(dirname "$0")" && pwd)"
cd $TOP_DIR

##- Get the GCC-related variables for this build.
##
source ./gcc-build-vars.sh

##- Make the dummy installation directory.
##
mkdir -p $GCC_STAGEDIR/usr/local/bin

##- Install GCC itself.
##
cd $GCC_BLD_DIR
$GCC_MAKE install DESTDIR=$GCC_STAGEDIR

##- If requested, install custom binutils.
##
if [ "$GCC_PLATFORM" == "Linux" ] && [ "$GCC_USE_NEWER_BINUTILS" == "YES" ]
then
    cd $BU_BLD_DIR
    $GCC_MAKE install-gas DESTDIR=$GCC_STAGEDIR
    $GCC_MAKE install-ld  DESTDIR=$GCC_STAGEDIR

    cd $GCC_SRC_DIR
    GCC_TRIPLE=`config.guess`
    GCC_EXEC_DIR=libexec/gcc/$GCC_TRIPLE/$GCC_VERSION
    cp -v $GCC_STAGEDIR/usr/local/bin/as  $GCC_STAGEDIR/$GCC_INSTALL_PREFIX/$GCC_EXEC_DIR
    cp -v $GCC_STAGEDIR/usr/local/bin/ld* $GCC_STAGEDIR/$GCC_INSTALL_PREFIX/$GCC_EXEC_DIR
fi

##- Install helper scripts and create helper links.
##
cd $TOP_DIR

sed "s|ABCXYZ|$GCC_INSTALL_PREFIX|" \
    ./setenv-for-gcc.sh  >          \
    ./setenv-for-gcc$GCC_TAG.sh
chmod 755 ./setenv-for-gcc$GCC_TAG.sh
mv -vf ./setenv-for-gcc$GCC_TAG.sh        $GCC_STAGEDIR/usr/local/bin

cp -v ./restore-default-paths.sh ./restore-default-paths-gcc$GCC_TAG.sh
chmod 755 ./restore-default-paths-gcc$GCC_TAG.sh
mv -vf ./restore-default-paths-gcc$GCC_TAG.sh $GCC_STAGEDIR/usr/local/bin

cd $GCC_STAGEDIR/usr/local/bin

ln -vf -s $GCC_INSTALL_PREFIX/bin/gcc gcc$GCC_TAG
ln -vf -s $GCC_INSTALL_PREFIX/bin/g++ g++$GCC_TAG

cd $GCC_STAGEDIR/$GCC_INSTALL_RELDIR/bin
ln -vf -s gcc cc
ln -vf -s g++ c++

ln -vf -s gcc gcc-$GCC_MAJOR_VERSION
ln -vf -s g++ g++-$GCC_MAJOR_VERSION

##- Touch all the files to have the desired timestamp.
##
cd $GCC_STAGEDIR
find $GCC_STAGEDIR/$GCC_INSTALL_RELDIR -exec touch -h -t $GCC_TIME_STAMP {} \+

cd $GCC_STAGEDIR/usr/local/bin
touch -h -t $GCC_TIME_STAMP gcc$GCC_TAG
touch -h -t $GCC_TIME_STAMP g++$GCC_TAG
touch -h -t $GCC_TIME_STAMP setenv-for-gcc$GCC_TAG.sh
touch -h -t $GCC_TIME_STAMP restore-default-paths-gcc$GCC_TAG.sh
