#!/bin/sh

if [ -n "$ORIGINAL_PATH" ]
then
    if [ "$ORIGINAL_PATH" == "<undef>" ]
    then
        BASIC_PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
        export PATH=$TOOL_ROOT/bin:$BASIC_PATH:$HOME/.local/bin:$HOME/bin:.
    else
        export PATH=$ORIGINAL_PATH
    fi
fi

if [ -n "$ORIGINAL_LD_LIBRARY_PATH" ]
then
    if [ "$ORIGINAL_LD_LIBRARY_PATH" == "<undef>" ]
    then
        unset LD_LIBRARY_PATH
    else
        export LD_LIBRARY_PATH=$ORIGINAL_LD_LIBRARY_PATH
    fi
fi

if [ -n "$ORIGINAL_MANPATH" ]
then
    if [ "$ORIGINAL_MANPATH" == "<undef>" ]
    then
        unset MANPATH
    else
        export MANPATH=$ORIGINAL_MANPATH
    fi
fi
