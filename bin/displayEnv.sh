#!/usr/bin/env bash

# A script to gather some overall data about the host machine
# Including
# IP Address of the machine
# Client IP (if connected by ssh)
# Distro (if Linux)
# CPU Count, CPU Model, CPU Speed
# Total Memory, Free Memory and Free Memory Percentage in terms of Total Memory
# CPU Load
# Kernel Version

source "$envHomeDir/bash/lib.sh"

setupColors

IP_ADDRESS="";
MY_CLIENT_IP="";
CPU_MODEL="";
CPU_SPEED="";
CPU_COUNT="";
MEM_FREE="";
MEM_TOTAL="";
MEM_FREE_PCNT="";
DISTRO="";
DISTRO_VER="";
KERNEL=`uname -r`
LOAD=`w | grep up | awk '{print $10" "$11" "$12}'`
if [ "$envPlatform" = "Mac" ]; then
    DISTRO="Mac"
    IP_ADDRESS=`ifconfig | grep 'inet ' | grep -v '127.0.0.1' | cut -c 7-17 | head -1`
    CPU_MODEL=`/usr/sbin/system_profiler SPHardwareDataType | grep "Processor Name" | cut -d : -f2`
    CPU_SPEED=`/usr/sbin/system_profiler SPHardwareDataType | grep "Processor Speed" | cut -d : -f2`
    CPU_SPEED=" @ $CPU_SPEED";
    CPU_COUNT=`sysctl -n hw.ncpu`

    MEM_FREE=`\top -l 1 | grep PhysMem | awk '{printf $6}'`
    length=${#MEM_FREE}
    ((length--))
    if [[ $MEM_FREE=~/\d+M/ ]]; then
        MEM_FREE=${MEM_FREE:0:length}
        MEM_FREE=$((MEM_FREE*1024*1024))
    elif [[ $MEM_FREE=~/\d+G/ ]]; then
        MEM_FREE=${MEM_FREE:0:length}
        MEM_FREE=$((MEM_FREE*1024*1024*1024))
    fi
    MEM_TOTAL=`sysctl hw.memsize | awk '{printf $2}'`
    MEM_FREE_PCNT=$((100*$MEM_FREE/$MEM_TOTAL))
    MEM_TOTAL=`bytesToDisplay $MEM_TOTAL`
    MEM_FREE=`bytesToDisplay $MEM_FREE`
else
    IP_ADDRESS=`/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d t -f2 | cut -d : -f2 | cut -b -12 | head -1`
    CPU_SPEED=`grep "cpu MHz" /proc/cpuinfo | cut -d : -f2 | head -1`;
    CPU_MODEL=`grep "model name" /proc/cpuinfo | cut -d : -f2 | head -1`;
    CPU_COUNT=`grep "processor" /proc/cpuinfo | cut -d : -f2 | tail -1`;
    CPU_COUNT=$(echo "$[$CPU_COUNT+1]" );

    MEM_FREE=`cat /proc/meminfo | grep MemFree | cut -d: -f2 | cut -dk -f1`;
    MEM_TOTAL=`cat /proc/meminfo | grep MemTotal | cut -d: -f2 | cut -dk -f1`;
    MEM_TOTAL=$(echo "$[$MEM_TOTAL*1/1024]");
    MEM_FREE=$(echo "$[$MEM_FREE*1/1024]" );
    MEM_FREE_PCNT=$(echo "$[100*$MEM_FREE/$MEM_TOTAL]" );

    DISTRO="Unknown Distro"
    DISTRO_VER="Unknown Distro"
    test -r "/etc/slackware-version" && DISTRO_VER=`cat /etc/slackware-version` && DISTRO="Slackware"
    test -r "/etc/debian_version" && DISTRO_VER=`cat /etc/debian_version` && DISTRO="Debian"
    test -r "/etc/redhat-release" && DISTRO_VER=`cat /etc/redhat-release` && DISTRO="Redhat"
    test -r "/etc/SuSE-release" && DISTRO_VER=`cat /etc/SuSE-release` && DISTRO="SuSe"
    test -r "/etc/gentoo-release" && DISTRO_VER=`cat /etc/gentoo-release` && DISTRO="Gentoo"
    test -r "/etc/turbolinux-release" && DISTRO_VER=`cat /etc/turbolinux-release` && DISTRO="TurboLinux"
fi

if [ ! -z "${SSH_CONNECTION+x}" ]; then
    MY_CLIENT_IP=`echo $SSH_CONNECTION | awk '{print $1}'`;
fi

printf "%14s: $Blue $IP_ADDRESS $NC \n" "IP Address";
printf "%14s: $Red ${MY_CLIENT_IP:-local} $NC \n" "Client Ip" ;
printf "\n" ;
printf "%14s: $Blue $DISTRO $DISTRO_VER $NC \n" "Distro" ;
printf "%14s: $Blue $CPU_COUNT x $CPU_MODEL $CPU_SPEED $NC \n" "CPU" ;
printf "%14s: $Red $MEM_TOTAL $NC \n" "Total Memory";
printf "%14s: $Red $MEM_FREE ($MEM_FREE_PCNT %%) $NC \n" "Free Memory";
printf "%14s: $Purple $LOAD $NC \n" "Load";
printf "%14s: $Purple $KERNEL $NC \n" "Kernel";
