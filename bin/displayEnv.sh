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

source "$ENV_HOME_DIR/bash/lib.sh"

setupColors

IP4_UP="";
DNS_UP="";
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

if [ "$ENV_PLATFORM" = "Mac" ]; then
    DISTRO="Mac OS X"
    DISTRO_VER=$(sw_vers | grep ProductVersion | cut -f 2)
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
    LOAD=`w | grep up | awk '{print $12" "$11" "$12}'`
    LOAD15=$(echo $LOAD | cut -f 3 -d ' ');
else
    IP_ADDRESS=`/sbin/ifconfig eth0 | grep 'inet ' | cut -d t -f2 | cut -d : -f2 | cut -d ' ' -f2 | head -1`
    CPU_SPEED=`grep "cpu MHz" /proc/cpuinfo | cut -d : -f2 | head -1`;
    CPU_MODEL=`grep "model name" /proc/cpuinfo | cut -d : -f2 | head -1`;
    CPU_COUNT=`grep "processor" /proc/cpuinfo | cut -d : -f2 | tail -1`;
    CPU_COUNT=$(echo "$[$CPU_COUNT+1]" );

    MEM_FREE=`cat /proc/meminfo | grep MemFree | cut -d: -f2 | cut -dk -f1`;
    MEM_TOTAL=`cat /proc/meminfo | grep MemTotal | cut -d: -f2 | cut -dk -f1`;
    MEM_TOTAL=$(echo "$[$MEM_TOTAL*1024]");
    MEM_FREE=$(echo "$[$MEM_FREE*1024]" );
    MEM_FREE_PCNT=$(echo "$[100*$MEM_FREE/$MEM_TOTAL]" );
    MEM_TOTAL=`bytesToDisplay $MEM_TOTAL`
    MEM_FREE=`bytesToDisplay $MEM_FREE`

    DISTRO="Unknown Distro"
    DISTRO_VER="Unknown Distro"
    if [ -f "/etc/os-release" ]; then
        . "/etc/os-release"
        DISTRO_VER=$VERSION
        DISTRO=$NAME
    else
        test -r "/etc/slackware-version" && DISTRO_VER=`cat /etc/slackware-version` && DISTRO="Slackware"
        test -r "/etc/debian_version" && DISTRO_VER=`cat /etc/debian_version` && DISTRO="Debian"
        test -r "/etc/redhat-release" && DISTRO_VER=`cat /etc/redhat-release` && DISTRO="Redhat"
        test -r "/etc/SuSE-release" && DISTRO_VER=`cat /etc/SuSE-release` && DISTRO="SuSe"
        test -r "/etc/gentoo-release" && DISTRO_VER=`cat /etc/gentoo-release` && DISTRO="Gentoo"
        test -r "/etc/turbolinux-release" && DISTRO_VER=`cat /etc/turbolinux-release` && DISTRO="TurboLinux"
    fi
    LOAD=`w | grep up | awk '{print $9" "$10" "$11}'`
    LOAD15=$(echo $LOAD | cut -f 3 -d ',');
fi

if [ `command -v curl` ]; then
    case "$(curl -s --max-time 2 -I http://google.com | sed 's/^[^ ]*  *\([0-9]\).*/\1/; 1q')" in
      [23]) HTTP_OK="true"
        ;;
      *) HTTP_OK="false"
        ;;
    esac
fi

if [ `command -v ping` ]; then
    if ping -q -c 1 -W 1 8.8.8.8 >/dev/null 2>&1; then
        IP4_UP="true"
    else
        IP4_UP="false"
    fi

    if ping -q -c 1 -W 1 google.com >/dev/null 2>&1; then
        DNS_UP="true"
    else
        DNS_UP="false"
    fi
fi


if [ ! -z "${SSH_CONNECTION+x}" ]; then
    MY_CLIENT_IP=`echo $SSH_CONNECTION | awk '{print $1}'`;
fi

if [ ! -t 1 ]; then
    NC=""
    Red=""
    Blue=""
fi

if [ $IP4_UP = "true" ]; then
    if [ $DNS_UP = "true" ]; then
        if [ $HTTP_OK = "false" ]; then
            printf "%14s: $NC $IP4_UP ($Red NO HTTP $NC) \n" "IP4 is Up";
        else
            printf "%14s: $NC $IP4_UP \n" "IP4 is Up";
        fi
    else
        printf "%14s: $NC $IP4_UP ($Red DNS is DOWN $NC) \n" "IP4 is Up";
    fi
elif [ `command -v ping` ]; then
    printf "%14s: $Red $IP4_UP $NC \n" "IP4 is Up";
else
    printf "%14s: $Red $IP4_UP (no ping) $NC \n" "IP4 is Up";
fi
printf "%14s: $NC $IP_ADDRESS $NC \n" "IP Address";
printf "%14s: $NC ${MY_CLIENT_IP:-local} $NC \n" "SSH Client IP" ;
printf "\n" ;
printf "%14s: $NC $DISTRO $DISTRO_VER $NC \n" "Distro" ;
printf "%14s: $NC $CPU_COUNT x $CPU_MODEL $CPU_SPEED $NC \n" "CPU" ;
printf "%14s: $NC $MEM_TOTAL $NC \n" "Total Memory";
printf "%14s: $NC $MEM_FREE $NC ($MEM_FREE_PCNT %%)\n" "Free Memory";
if [[ "$LOAD15" > "$CPU_COUNT" ]]; then
    printf "%14s: $Red $LOAD $NC\n" "Load";
else
    printf "%14s: $NC $LOAD $NC\n" "Load";
fi
printf "%14s: $NC $KERNEL $NC \n" "Kernel";
