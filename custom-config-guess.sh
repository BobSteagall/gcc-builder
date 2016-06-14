#!/bin/bash
##
##  Script: custom-config-guess.sh
##
##  This second-level script returns the (possibly customized) GCC triple.
##
##- Get the directory this script resides in so we can be sure to run the
##  correct version of the original guessing script.
##
export THIS_DIR="$(cd "$(dirname "$0")" && pwd)"
export ORIG_GUESS=$THIS_DIR/config.guess-orig

##- Update the name, if a custom build is specified.
##
if [ -z $GCC_CUSTOM_BUILD_STR ]
then
    echo `$ORIG_GUESS`
else
    echo `$ORIG_GUESS | sed -r s/-unknown-\|-pc-/-$GCC_CUSTOM_BUILD_STR-/`
fi
exit
