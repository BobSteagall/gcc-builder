#!/bin/bash
##
##  Script: make-gcc-rpm.sh
##
##  This top-level script makes an RPM from the files installed into the
##  staging directory.
##
##- Make sure we're in the same directory as this script.
##
TOP_DIR="$(cd "$(dirname "$0")" && pwd)"
cd $TOP_DIR

##- Get the GCC-related variables for this build.
##
source ./gcc-build-vars.sh

GCC_TAG=
RELEASE_VERSION="0"
WORK_DIR=$TOP_DIR/packages
RPM_QUIET="--quiet"
CP="cp"
MKDIR="mkdir -p"
BO_ROOT_DIR=$RPMBUILD_SRCDIR

function usage () 
{
    echo "usage: make-gcc-rpm.sh [-w <work_root_dir>]"
    echo "                       [-v]"
    exit 1
}

##- Parse and validate required  command-line arguments.  Overrides supported.
##
while getopts ":w:v" opt
do
    case $opt in
        w ) WORK_DIR=`readlink -f $OPTARG`
            ;;
        v ) RPM_QUIET=""
            CP="cp -v"
            MKDIR="mkdir -pv"
            ;;
        * ) usage
            exit 1 ;;
    esac
done
shift $((OPTIND - 1))

if [ -z "$GCC_VERSION" ]; then
    echo "gcc version not specified"
    usage
fi

if [ -z "$RELEASE_VERSION" ]; then
    echo "RPM release number not specified"
    usage
fi

BO_ROOT_DIR=`readlink -f $BO_ROOT_DIR`

if [ -x $BO_ROOT_DIR/$GCC_INSTALL_RELDIR/bin/gcc ]; then
    echo "Found GCC $GCC_VERSION in $BO_ROOT_DIR/$GCC_INSTALL_RELDIR"
    GCC_TAG=`echo $GCC_VERSION | tr -d .`
else
    echo "GCC $GCC_VERSION was not found"
    exit 1
fi

if [ -d $WORK_DIR ]; then
    echo "Using $WORK_DIR as work directory"
else
    echo "Attempting to make work directory $WORK_DIR"
    mkdir -p $WORK_DIR

    if [ -d $WORK_DIR ]; then
        echo "Using $WORK_DIR as work directory"
    else
        echo "Invalid work directory $WORK_DIR"
        exit 1
    fi
fi

##- Retrieve useful information about the platform.
##
PLATFORM_INFO=(`$TOP_DIR/system-type.sh -f`)
PLATFORM_OS=${PLATFORM_INFO[0]}
PLATFORM_NAME=${PLATFORM_INFO[1]}
PLATFORM_ARCH=${PLATFORM_INFO[4]}
PLATFORM_DESC=${PLATFORM_INFO[5]}

if [ "$PLATFORM_OS" = "FreeBSD" ] && [ "$PLATFORM_ARCH" = "amd64" ]; then
    PLATFORM_ARCH=x86_64
fi

##- Form the release string (e.g., 3.el6 or 1.bsd10).
##
RPM_RELEASE=${RELEASE_VERSION}.${PLATFORM_DESC}

##- Copy the spec file into the SPECS directory for rpmbuild to use.
##
$MKDIR $WORK_DIR/SPECS

SPEC_FILE=$WORK_DIR/SPECS/gcc$GCC_TAG.spec
$CP $TOP_DIR/gcc.spec $SPEC_FILE

##- Determine the output directory.
##
OUTPUT_DIR=$WORK_DIR

##- Define the build command.
##
function rpmcmd ()
{
    rpmbuild -bb $RPM_QUIET                             \
    --define "build_root_dir $BO_ROOT_DIR"              \
    --define "gcc_install_dir $GCC_INSTALL_DIR"         \
    --define "gcc_install_reldir $GCC_INSTALL_RELDIR"   \
    --define "gcc_tag $GCC_TAG"                         \
    --define "gcc_version $GCC_VERSION"                 \
    --define "gcc_rpm_release $RPM_RELEASE"             \
    --define "product_arch $PLATFORM_ARCH"              \
    --define "product_os $PLATFORM_OS"                  \
    --define "_topdir $WORK_DIR"                        \
    --define "_tmppath $WORK_DIR/TMP"                   \
    --define "_rpmdir $OUTPUT_DIR"                      \
    --define "_build_name_fmt %%{NAME}-%%{RELEASE}.%%{ARCH}.rpm" \
    $SPEC_FILE
}

echo "Building GCC RPM using:"
echo "   GCC_VERSION  = $GCC_VERSION"
echo "   GCC_TAG      = $GCC_TAG"
echo "   INSTALL_DIR  = $GCC_INSTALL_DIR"
echo "   RPM_RELEASE  = $RPM_RELEASE"
echo "   PRODUCT_ARCH = $PLATFORM_ARCH"
echo "   PRODUCT_OS   = $PLATFORM_OS"

rpmcmd

exit 0
