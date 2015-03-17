#!/bin/sh

# Check and disallow for 1.5GB diskspace is not present on the system 
if [ -d /u01/app/oracle ] 
then
	diskspace=`df -k /u01/app/oracle | grep % | tr -s " " | cut -d" " -f4 | tail -1`
	diskspace=`expr $diskspace / 1024`
	if [ $diskspace -lt 1536 ]
	then
	echo "You have insufficient diskspace in the destination directory (/u01/app/oracle) 
to install Oracle Database 11g Express Edition.  The installation requires at 
least 1.5 GB free on this disk."
        exit 1
	fi
elif [ -d /u01/app ]
then
	diskspace=`df -k /u01/app | grep % | tr -s " " | cut -d" " -f4 | tail -1`
	diskspace=`expr $diskspace / 1024`
	if [ $diskspace -lt 1536 ]
	then
	echo "You have insufficient diskspace in the destination directory (/u01/app) to 
install Oracle Database 11g Express Edition.  The installation requires at 
least 1.5 GB free on this disk."
        exit 1
	fi
elif [ -d /u01 ]
then
	diskspace=`df -k /u01 | grep % | tr -s " " | cut -d" " -f4 | tail -1`
	diskspace=`expr $diskspace / 1024`
        if [ $diskspace -lt 1536 ]
        then
        echo "You have insufficient diskspace in the destination directory (/u01) to
install Oracle Database 11g Express Edition.  The installation requires at
least 1.5 GB free on this disk."
        exit 1
        fi
else
	diskspace=`df -k / | grep % | tr -s " " | cut -d" " -f4 | tail -1`
	diskspace=`expr $diskspace / 1024`
	if [ $diskspace -lt 1536 ]
        then
        echo "You have insufficient diskspace to install Oracle Database 11g Express Edition.
 The installation requires at least 1.5 GB free diskspace."
        exit 1
        fi
fi

# Check and disallow install, if RAM is less than 256 MB
space=`cat /proc/meminfo | grep '^MemTotal' | awk '{print $2}'`
PhyMem=`expr $space / 1024`
swapspace=`free -m | grep Swap | awk '{print $4}'`

if [ $PhyMem -lt 256 ]
then
        echo "Oracle Database 11g Express Edition requires a minimum of 256 MB of physical 
memory (RAM).  This system has $PhyMem MB of RAM and does not meet minimum 
requirements."
	echo
        exit 1
fi

reqswapspace=`echo 2 \* $PhyMem | bc`

min() {
    echo "$@" | tr '[[:space:]]' '\n' \
     | grep -Ee '^-?[[:digit:],]*(.[[:digit:]]+)?$' \
     | sort -n | sed 1q
}

requiredswapspace=`min 2047 $reqswapspace`

# check and disallow install, if swap space is less than Min( 2047, 2 * RAM)
if [ $swapspace -lt $requiredswapspace ]
then
	if [ "$requiredswapspace" = "2047" ];
	then
		requiredswapspace=2048
	fi
	echo
        echo "This system does not meet the minimum requirements for swap space.  Based on
the amount of physical memory available on the system, Oracle Database 11g
Express Edition requires $requiredswapspace MB of swap space. This system has $swapspace MB
of swap space.  Configure more swap space on the system and retry the 
installation."
	echo
        exit 1
fi

echo "Prerequisite checks for Oracle 11gR2 XE passed!"
echo "Deployment will continue..."
