# By Sezgin Sucu

# prependPath VARNAME /path/to/existing/dir
# prepends the second argument to the ENVVAR and exports ENVVAR
# it prepends the path if VARNAME does not have it already
# the path should exist in the system
prependPath()
{
    # check if $1 already has this path
    local hasThisPath=f
    local envVar=""
    eval envVar=\"\$$1\"
    for i in $(echo $envVar | tr ":" "\n")
    do
	if [ "$i" = "$2" ]; then
	    hasThisPath=t
	    break;
	fi
    done
    # if $2 path exists and $1 does not have this path
    if [ -d "$2" -a "$hasThisPath" = "f" ]; then
	    eval $1=\"$2\$\{$1:+':'\$$1\}\" && export $1 ;
    fi
}


function disableCore()
{
   ulimit -S -c 0
}

# on macs they are written to /cores
function enableCore()
{
   ulimit -S -c unlimited
}

# find files/directories with a pattern in name:
# ex: findFiles "*~"
function findFiles()
{
    eval find . -name \"${1:-}\"  ;
}

# find a file with pattern $1 in name and Execute $2 on it:
# ex: findExecute "*.cc" 'ls -l'
# to remove all Emacs backup files: findExecute "*~" 'rm -f'
function findExecute()
{
    eval find . -type f -name \"${1:-}\" -exec ${2:-ls} '{}' \\\;  ;
}

# Find files with a given pattern $2 in name which is younger than $1 minutes
# ex: findRecentlyModified 180
# ex: findRecentlyModified 180 "*.cc"
function findRecentlyModified()
{
    if [ $# -eq 0 ]
      then
        echo 'Usage: findRecentlyModified 180 or findRecentlyModified 180 "*.cc"'
        echo 'Find files with a given pattern $2 (defaults to all files) in name which is younger than $1 minutes'
    else
        eval find . -type f -name \"${2:-*}\" -mmin -$1 ;
    fi
}

# find files with a given pattern $2 in name which is younger than $1 days
# ex: findRecentlyModifiedInDays 2
# ex: findRecentlyModifiedInDays 2 "*.cc"
function findRecentlyModifiedInDays()
{
    if [ $# -eq 0 ]
      then
        echo 'Usage: findRecentlyModifiedInDays 2 or findRecentlyModifiedInDays 2 "*.cc"'
        echo 'Find files with a given pattern $2 (defaults to all files) in name which is younger than $1 days'
    else
        eval find . -type f -name \"${2:-*}\" -mtime -$1 ;
    fi
}

# find a file with pattern $2 in name and grep files that contain $1
# ex: findGrep "envvar"
# ex: findGrep "envvar" "*.sh"
function findGrep()
{
    if [ $# -eq 0 ]
      then
        echo 'Usage: findGrep "envvar" or findGrep "envvar "*.sh"'
        echo 'Find a file with pattern $2 (defaults to all files) in name and grep files that contain $1'
    else
        findExecute "${2:-*}" "grep -c -H '${1:-}'"
    fi
}

# case insensitive version of findGrep
# ex: findGrepi "envvar"
# ex: findGrepi "envvar" "*.sh"
function findGrepi()
{
    findExecute "${2:-*}" "grep -c -H -i '${1:-}'"
}

# find all files that are over the given size
# ex: findOverSize 10M
# ex: findOverSize 10M "*.log"
# ex: findOverSize 10k
function findOverSize()
{
    if [ $# -eq 0 ]
      then
        echo 'Usage: findOverSize 10M or findOverSize 10k "*.cc"'
        echo 'Find all files that are over the given size'
    else
        # make k,M,G case insensitive, so K, m, g also work
        local sizeStr=$1
        local length=${#sizeStr}
        ((length--))
        if [ "${sizeStr:length:1}" = "K" ]; then
            sizeStr=${sizeStr:0:length}"k"
        elif [ "${sizeStr:length:1}" = "m" ]; then
            sizeStr=${sizeStr:0:length}"M"
        elif [ "${sizeStr:length:1}" = "g" ]; then
            sizeStr=${sizeStr:0:length}"G"
        fi
        if [ "$envPlatform" = "Mac" ]; then
            eval find . -type f -name \"${2:-*}\" -size +$sizeStr -print0 | xargs -n1 -0 ls -lhG;
        else
            eval find . -type f -name \"${2:-*}\" -size +$sizeStr -print0 | xargs --no-run-if-empty -n1 -0 ls -lh --color;
        fi
    fi
}

# recursively delete all files specified with $1
function removeFiles()
{
    if [ $# -eq 0 ]
      then
        echo "Usage: removeFiles '*.class'"
        echo 'Remove all files that match the given criteria'
    else
        findExecute "$1" 'rm -f'
    fi
}

#For Regular Consoles
setupConsoleColors()
{
    NC='\033[0m'

    Blue='\e[1;34m'
    Purple='\e[1;35m'
    Red="\e[1;31m"
    White='\e[1;37m'

    BlackBG='\e[40m'
}

#For Xterm Consoles
setupXtermColors()
{

    NC="$(tput sgr0)"       # No Color

    Blue="$(tput bold ; tput setaf 4)"
    Purple="$(tput bold ; tput setaf 5)"
    Red="$(tput bold ; tput setaf 1)"
    White="$(tput bold ; tput setaf 7)"

    BlackBG="$(tput setab 0)"
}

#For Any console
setupColors()
{
    case "$TERM" in
        *term | rxvt)
            setupXtermColors;
            ;;
        *)
            setupConsoleColors;
            ;;
    esac
}

# X Window Related
getXServer()
{
    case $TERM in
       xterm )
            XSERVER=$(who am i | awk '{print $NF}' | tr -d ')''(' )
            XSERVER=${XSERVER%%:*}
            ;;
    esac
}

function setupDisplay ()
{
   if [ -z ${DISPLAY:=""} ]; then
       getXServer;
       if [[ -z ${XSERVER:=""}  || ${XSERVER} == $(hostname) || ${XSERVER} == "unix" ]]; then
          DISPLAY=":0.0"          # Localhost
       else
          DISPLAY=${XSERVER}:0.0  # Remote
       fi
   fi
   export DISPLAY
}

# Setting X Title
function resetTitle()
{
    #export PROMPT_COMMAND='echo -ne "\033]0;${USER}@[`uname -m`]${HOSTNAME}: ${PWD}\007"'
    #export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
    export PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME}\007"'
}

# You can use this function from shell to custom set the title
function setTitle()
{
    case "$TERM" in
        *term | rxvt | xterm-256color)
            echo -n -e "\033]0;$*\007" ;;
        *)
            ;;
    esac
    export PROMPT_COMMAND=
}

# Usage:
# compress final.tar.gz File1 File2 File3
# compress final.tar.gz Directory1 Directory2 File1 ...
function compress () {
   local file=$1
   shift
   case $file in
      *.tar)     tar cvf $file $*  ;;
      *.tar.bz2) tar cjf $file $*  ;;
      *.tar.gz)  tar czf $file $*  ;;
      *.tgz)     tar czf $file $*  ;;
      *.zip)     zip $file $*      ;;
      *)         echo "File type not recognized" ;;
   esac
}

# Usage:
# xtract test.tar.gz
# xxtract test.bz2
function xtract()
{
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xvjf $1     ;;
             *.tar.gz)    tar xvzf $1     ;;
             *.bz2)       bunzip2 $1      ;;
             *.gz)        gunzip $1       ;;
             *.tar)       tar xvf $1      ;;
             *.tbz2)      tar xvjf $1     ;;
             *.tgz)       tar xvzf $1     ;;
             *.zip)       unzip $1        ;;
             *.Z)         uncompress $1   ;;
             *)           echo "'$1' cannot be extracted via >extract<" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

# To generate TAGS to be used in emacs
function generateTags()
{
    local ETAGS_COMMAND=`which etags`
    if [ -e TAGS ]; then
        \rm TAGS
    fi
    eval find . -name "*.cxx" -o -name "*.hxx" -o -name "*.cpp" -o -name "*.cc" -o -name "*.h" -o -name "*.hh" -o -name "*.hpp" -o -name "*.c" | xargs $ETAGS_COMMAND --append --declarations --language=c++
}


function toEpochF()
{
    if [ $# -eq 0 ]; then
        echo "Usage: toEpochF '%Y-%m-%d %H:%M:%S %Z' '2018-07-25 14:36:02 UTC'"
        echo 'Convert the given date to epoch seconds since 1970'
    else
        local format=$1
        shift
        if [ "$envPlatform" = "Mac" ]; then
            date -j -f "$format" "$*" +"%s"
        elif [ "$envPlatform" = "Linux" ]; then
            date -d "$*" '+%s'
        else
            echo "Not Supported"
            exit 1
        fi
    fi
}

function fromEpochF()
{
    local format=$1
    shift
    if [ "$envPlatform" = "Mac" ]; then
        date -r $1 "+$format"
    elif [ "$envPlatform" = "Linux" ]; then
        date -d "@$1" "+$format"
    else
        echo "Not Supported"
        exit 1
    fi
}


function toEpoch()
{
    toEpochF "$ISO_DATE_FMT" $*
}

function fromEpoch()
{
    fromEpochF "$ISO_DATE_FMT" $*
}

function displayEnv ()
{
    local IP_ADDRESS="";
    local MYIP="";
    local CPU_MODEL="";
    local CPU_SEED="";
    local CPU_COUNT="";
    local MEM_FREE="";
    local MEM_USED="";
    local MEM_TOTAL="";
    local MEM_FREE="";
    local MEM_FREE_PCNT="";
    local DISTRO="";
    local DISTRO_VER="";
    local KERNEL=`uname -r`
    local LOAD=`w | grep up | awk '{print $10" "$11" "$12}'`
    if [ "$envPlatform" = "Mac" ]; then
        DISTRO="Mac"
        IP_ADDRESS=`ifconfig | grep 'inet ' | grep -v '127.0.0.1' | cut -c 7-17 | head -1`
        CPU_MODEL=`/usr/sbin/system_profiler SPHardwareDataType | grep "Processor Name" | cut -d : -f2`
        CPU_SPEED=`/usr/sbin/system_profiler SPHardwareDataType | grep "Processor Speed" | cut -d : -f2`
        CPU_SPEED=" @ $CPU_SPEED";
        CPU_COUNT=`/usr/sbin/system_profiler SPHardwareDataType | grep "Total Number Of Cores" | cut -d : -f2`

        MEM_FREE=`top -l 1 | grep PhysMem | awk '{printf $10}' | cut -d M -f1`
        MEM_USED=`top -l 1 | grep PhysMem | awk '{printf $8}' | cut -d M -f1`
        MEM_TOTAL=$(echo "$[$MEM_USED+$MEM_TOTAL+0]" );
        MEM_FREE_PCNT=$(echo "$[100*$MEM_FREE/$MEM_TOTAL]" );
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

    if [ ! -z "$SSH_CONNECTION" ]; then
	    MYIP=`echo $SSH_CONNECTION | awk '{print $1}'`;
    fi

    printf "%14s: $Red $MYIP $NC \n" "My Ip" ;
    printf "%14s: $Blue $DISTRO $DISTRO_VER $NC \n" "Distro" ;
    printf "%14s: $Blue $CPU_COUNT x $CPU_MODEL $CPU_SPEED $NC \n" "CPU" ;
    printf "%14s: $Blue $IP_ADDRESS $NC \n" "IP Address";
    printf "%14s: $Purple $KERNEL $NC \n" "Kernel";
    printf "%14s: $Red $MEM_TOTAL MBs $NC \n" "Total Memory";
    printf "%14s: $Red $MEM_FREE MBs ($MEM_FREE_PCNT %%) $NC \n" "Free Memory";
    printf "%14s: $Purple $LOAD $NC \n" "Load";
}

function git_prompt()
{
    local repo=$(git rev-parse --show-toplevel 2> /dev/null)
    if [[ -e $repo ]]; then
        local response=`git branch 2>/dev/null | grep '^*' | colrm 1 2`
        local git_status=$(LC_ALL=C git status --untracked-files=normal --porcelain)
        if [[ "$?" -ne 0 ]]; then
            echo "(error)";
            return
        fi
        # below code is from (modified from original version)
        # https://github.com/magicmonty/bash-git-prompt/blob/master/LICENSE.txt
        local staged_count=0
        local modified_count=0
        local conflict_count=0
        local untracked_count=0
        local status=''
        local line=''
        while IFS='' read -r line || [[ -n "$line" ]]; do
            status=${line:0:2}
            while [[ -n $status ]]; do
                case "$status" in
                    \?\?)
                            ((untracked_count++));
                            local file=${line:3}
                            if [[ $file =~ ^\..* ]]; then
                                ((untracked_count--));
                            fi
                            break ;;
                    U?) ((conflict_count++)); break;;
                    ?U) ((conflict_count++)); break;;
                    DD) ((conflict_count++)); break;;
                    AA) ((conflict_count++)); break;;
                    #two character matches, first loop
                    ?M) ((modified_count++)) ;;
                    ?D) ((modified_count++)) ;;
                    ?\ ) ;;
                    #single character matches, second loop
                    U) ((conflict_count++)) ;;
                    \ ) ;;
                    *) ((staged_count++)) ;;
                esac
                status=${status:0:(${#status}-1)}
            done
        done <<< "$git_status"
        if [[ $modified_count > 0 || $conflict_count > 0 || $staged_count > 0 || $untracked_count > 0 ]]; then
            response="$response|"
            local putSpace=0
            [[ $conflict_count > 0 ]] && response="${response}x$conflict_count" && putSpace=1
            if [[ $modified_count > 0 ]]; then
                if [[ $putSpace == 1 ]]; then
                    response="$response "
                fi
                response="${response}+$modified_count"
                putSpace=1
            fi
            if [[ $staged_count > 0 ]]; then
                if [[ $putSpace == 1 ]]; then
                    response="$response "
                fi
                response="${response}*$staged_count"
                putSpace=1
            fi
            if [[ $untracked_count > 0 ]]; then
                if [[ $putSpace == 1 ]]; then
                    response="$response "
                fi
                response="${response}?$untracked_count"
            fi
        else
            response="{$response}✔"
        fi
        echo "($response)"
    else
        echo ''
    fi
}