#!/bin/sh

PATH=/bin:/usr/bin:/sbin:/usr/sbin
export PATH

platform_os=`uname`

if [ "$platform_os" = "Linux" ]; then

    platform_arch=`uname -p`
    platform_dist=`lsb_release -si | cut -d ' ' -f 1`
    platform_vnum=`lsb_release -sr | cut -d '.' -f 1`
    platform_mvnum=`lsb_release -sr | cut -d '.' -f 2`

    if [ -f /etc/centos-release ] ; then

        platform_desc='centos'

    elif [ -n "`echo $platform_dist | grep -i CentOS`" ] ; then

        platform_desc='centos'

    elif [ -f /etc/redhat-release ] ; then

        platform_desc='rhel'

    elif [ -n "`echo $platform_dist | grep -i RedHatEnterprise`" ] ; then

        platform_desc='rhel'

    elif [ "$platform_dist" = "Ubuntu" ]; then

        platform_desc='ubuntu'

    else

        platform_desc=`echo $platform_dist | cut -f1`
    fi

elif [ "$platform_os" = "FreeBSD" ]; then

    platform_arch='amd64'
    platform_dist=$platform_os
    platform_desc='bsd'
    platform_vnum=`uname -r | cut -d '.' -f 1`
    platform_mvnum=`lsb_release -sr | cut -d '.' -f 2`

else

    platform_arch='unknown'
    platform_dist='unknown'
    platform_desc='unknown'
    platform_vnum='0.0'

fi

if [ -n "$platform_mvnum" ]; then

    platform_vnum="$platform_vnum.$platform_mvnum"

fi

if [ $# -eq 0 ]; then

    echo $platform_dist-$platform_vnum

elif [ $1 = "--full" ]  ||  [ $1 = "-f" ]; then

    echo $platform_os                  \
         $platform_dist-$platform_vnum \
         $platform_dist $platform_vnum \
         $platform_arch                \
         $platform_desc

elif [ $1 = "--tag" ]  ||  [ $1 = "-t" ]; then

    echo $platform_desc-$platform_vnum

fi

exit 0
