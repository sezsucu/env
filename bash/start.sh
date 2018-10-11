# By Sezgin Sucu

# ENV_HOME_DIR: programs and configuration files
# ENV_DATA_DIR: host specific files or temp files
# ENV_ARCH: 32 or 64
# ENV_PLATFORM: Mac or Linux

# Never use an uninitialised variable
# unfortunately because of a bug I had to be disabled, keeping it here
# for occasional debugging
# set -u

# Find where we are installed at
INSTALL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export ENV_HOME_DIR=`dirname $INSTALL_DIR`;
export ENV_DATA_DIR=$HOME/.envData
export ENV_ARCH
export ENV_PLATFORM
#export envHasPython=`command -v python3`
#export envHasJava=`command -v java`
#export envHasJavaDev=`command -v javac`

# check the architecture
MACHINE_ARC=`uname -m`;
case "$MACHINE_ARC" in
    "x86_64")
	ENV_ARCH="64"
        ;;
    "*")
	ENV_ARCH="32"
	;;
esac

# check the platform
ENV_PLATFORM="Linux"
unameStr=`uname`
if [ "$unameStr" = "Darwin" ]; then
    ENV_PLATFORM="Mac";
fi

source $ENV_HOME_DIR/bash/settings.sh
if [ -f /etc/timezone ]; then
  LOCAL_TIME_ZONE=`cat /etc/timezone`
elif [ -h /etc/localtime ]; then
    LOCAL_TIME_ZONE=`readlink /etc/localtime`
    if [[ $LOCAL_TIME_ZONE =~ ^\/var\/db ]]; then
        LOCAL_TIME_ZONE=`readlink /etc/localtime | sed "s/\/var\/db\/timezone\/zoneinfo\///"`
    else
        LOCAL_TIME_ZONE=`readlink /etc/localtime | sed "s/\/usr\/share\/zoneinfo\///"`
    fi
fi


# setup the data dir used for temp data files
# bash: history file
# ssh: authorized_keys file
# emacs: backup files and module files
if [ ! -d $ENV_DATA_DIR ]; then
    mkdir $ENV_DATA_DIR
    mkdir $ENV_DATA_DIR/bash
    mkdir $ENV_DATA_DIR/ssh
    mkdir $ENV_DATA_DIR/emacs
    mkdir $ENV_DATA_DIR/emacs/backup
    mkdir $ENV_DATA_DIR/emacs/modules
fi

ISO_DATE_FMT='%Y-%m-%d %H:%M:%S %Z'
export TZ=Etc/UTC

# functions, utilities, etc..
source $ENV_HOME_DIR/bash/lib.sh

. $ENV_HOME_DIR/bash/aliases.sh
if [ "$ENV_PLATFORM" = "Mac" ]; then
    . $ENV_HOME_DIR/bash/mac/aliasesForMac.sh
else
    . $ENV_HOME_DIR/bash/linux/aliasesForLinux.sh
fi

# [Other Environment Variables]
#export HOSTNAME=`hostname`
export PAGER=less
export LESSCHARSET='utf-8'

# never logout due to inactivity
export TMOUT=0

# [Hosts]
export HOSTFILE=$ENV_DATA_DIR/bash/hosts
if [ -e $ENV_DATA_DIR/bash/hostVars.sh ]; then
    source $ENV_DATA_DIR/bash/hostVars.sh;
fi

# [History]
export HISTFILE=$ENV_DATA_DIR/bash/history
export HISTSIZE=10000
export HISTIGNORE="&:bg:fg:lsl:lsll:lsa:ls:history:exit"
export HISTCONTROL="ignoreboth"
# append to the history file, rather than overwrite it
shopt -s histappend
shopt -s histreedit
# allow me to edit the old command
shopt -s histverify

# [Security]
umask 022

# [Bash Other]
# don't allow output redirection overwritte the existing files
set -o noclobber

# don't allow use of CTRl-D to log off
set -o ignoreeof

# report the status of terminated bg jobs immediately
set -o notify

# show the list at first TAB, instead of beeping and and waiting for a second TAB
set show-all-if-ambiguous On

# disable messaging, turn off talk and write
mesg n

# don't attempt to search PATH for completions when on an empty line
shopt -s no_empty_cmd_completion

# check window size after each command, update the values of LINES and COLUMNS
shopt -s checkwinsize

# [Core Files]
disableCore
#enableCore

# [PATH]
prependPath PATH $ENV_HOME_DIR/bin/$ENV_PLATFORM/$ENV_ARCH
prependPath PATH $ENV_HOME_DIR/bin
if [ -e $ENV_DATA_DIR/bash/pathVars.sh ]; then
    source $ENV_DATA_DIR/bash/pathVars.sh;
fi

# [Locale]
# locale -a to see all available locales

# [Display]
setupDisplay;
setupColors;
resetTitle;

# [Prompt]
envHasGit=`command -v git`
if [ $envHasGit ]; then
    case $TERM in
        xterm*)
        PS1="\n\[$Blue\]\u\[$NC\][\$(localTime)]\[$Red\]\$(git_prompt)\[$NC\]:\[$BlackBG\]\[$White\]\w \[$NC\]\n% "
            ;;
        *)
            PS1="\n\[$Blue\]\u\[$NC\][\$(localTime)]\[$Red\]\$(git_prompt)\[$NC\]:\[$BlackBG\]\[$White\]\w \[$NC\]\n% "
            ;;
    esac
else
    case $TERM in
        xterm*)
        PS1="\n\[$Blue\]\u@\[$Red\]\h\[$NC\][\t]:\[$BlackBG\]\[$White\]\w \[$NC\]\n% "
            ;;
        *)
            PS1="\n\[$Blue\]\u@\[$Red\]\h\[$NC\][\t]:\[$BlackBG\]\[$White\]\w \[$NC\]\n% "
            ;;
    esac
fi

case "$-" in
    *i*) # interactive
        # [Keyboard Bindings]
        bind -f $ENV_HOME_DIR/etc/inputrc
        if [ -x xrdb ] ; then
            xrdb -load $ENV_HOME_DIR/etc/XDefaults
        fi
        ;;
    *) # non-interactive
        ;;
esac


