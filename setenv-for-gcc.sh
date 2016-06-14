#!/bin/bash

TOOL_ROOT=ABCXYZ

##- Handle PATH
##
if [ -z "$ORIGINAL_PATH" ]
then
    if [ -z "$PATH" ]
    then
        export ORIGINAL_PATH="<undef>"
    else
        export ORIGINAL_PATH=$PATH
    fi
fi

if [ "$ORIGINAL_PATH" == "<undef>" ]
then
    BASIC_PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
    export PATH=$TOOL_ROOT/bin:$BASIC_PATH:$HOME/.local/bin:$HOME/bin:.
else
    export PATH=$TOOL_ROOT/bin:$ORIGINAL_PATH
fi

##- Handle LD_LIBRARY_PATH
##
if [ -z "$ORIGINAL_LD_LIBRARY_PATH" ]
then
    if [ -z "$LD_LIBRARY_PATH" ]
    then
        export ORIGINAL_LD_LIBRARY_PATH="<undef>"
    else
        export ORIGINAL_LD_LIBRARY_PATH=$LD_LIBRARY_PATH
    fi
fi

if [ "$ORIGINAL_LD_LIBRARY_PATH" == "<undef>" ]
then
    export LD_LIBRARY_PATH=$TOOL_ROOT/lib:$TOOL_ROOT/lib64
else
    export LD_LIBRARY_PATH=$TOOL_ROOT/lib:$TOOL_ROOT/lib64:$ORIGINAL_LD_LIBRARY_PATH
fi

##- Handle MANPATH
##
if [ -z "$ORIGINAL_MANPATH" ]
then
    if [ -z "$MANPATH" ]
    then
        export ORIGINAL_MANPATH="<undef>"
        export ORIGINAL_MANPATH_DEFAULT=`manpath -q`
    else
        export ORIGINAL_MANPATH=$MANPATH
    fi
fi

if [ "$ORIGINAL_MANPATH" == "<undef>" ]
then
    export MANPATH=$TOOL_ROOT/share/man:$ORIGINAL_MANPATH_DEFAULT
else
    export MANPATH=$TOOL_ROOT/share/man:$MANPATH
fi
