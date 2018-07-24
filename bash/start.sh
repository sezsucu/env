# By Sezgin Sucu

# envHomeDir: programs and configuration files
# envDataDir: host specific files or temp files
# envArch: 32 or 64
# envPlatform: Mac or Linux

# Never use an uninitialised variable
set -u

# Find where we are installed at
INSTALL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export envHomeDir=`dirname $INSTALL_DIR`;
export envDataDir=$HOME/.envData
export envArch
export envPlatform
#export envHasPython=`command -v python3`
#export envHasJava=`command -v java`
#export envHasJavaDev=`command -v javac`

# check the architecture
MACHINE_ARC=`uname -m`;
case "$MACHINE_ARC" in
    "x86_64")
	envArch="64"
        ;;
    "*")
	envArch="32"
	;;
esac

# check the platform
envPlatform="Linux"
unameStr=`uname`
if [ "$unameStr" = "Darwin" ]; then
    envPlatform="Mac";
fi

# setup the data dir used for temp data files
# bash: history file
# ssh: authorized_keys file
# emacs: backup files
if [ ! -d $envDataDir ]; then
    mkdir $envDataDir
    mkdir $envDataDir/bash
    mkdir $envDataDir/ssh
    mkdir $envDataDir/emacs
fi

ISO_DATE_FMT='%Y-%m-%d %H:%M:%S %Z'

# functions, utilities, etc..
source $envHomeDir/bash/lib.sh

. $envHomeDir/bash/aliases.sh
if [ "$envPlatform" = "Mac" ]; then
    . $envHomeDir/bash/mac/aliasesForMac.sh
else
    . $envHomeDir/bash/linux/aliasesForLinux.sh
fi

# [Other Environment Variables]
export HOSTNAME=`hostname`
export PAGER=less
export LESSCHARSET='utf-8'

# never logout due to inactivity
export TMOUT=0

# [Hosts]
export HOSTFILE=$envDataDir/bash/hosts
if [ -e $envDataDir/bash/hostVars.sh ]; then
    source $envDataDir/bash/hostVars.sh;
fi

# [History]
export HISTFILE=$envDataDir/bash/history
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
prependPath PATH $envHomeDir/bin/$envPlatform/$envArch
prependPath PATH $envHomeDir/bin
if [ -e $envDataDir/bash/pathVars.sh ]; then
    source $envDataDir/bash/pathVars.sh;
fi

# [Locale]
# locale -a to see all available locales

# [Display]
setupDisplay;
setupColors;
resetTitle;

# [Prompt]
case $TERM in
    xterm*)
	PS1="\n\[$Blue\]\u@\[$Red\]\h\[$NC\][\t]:\[$BlackBG\]\[$White\]\w \[$NC\]\n% "
        ;;
    *)
        PS1="\n\[$Blue\]\u@\[$Red\]\h\[$NC\][\t]:\[$BlackBG\]\[$White\]\w \[$NC\]\n% "
        ;;
esac

case "$-" in
    *i*) # interactive
        # [Keyboard Bindings]
        bind -f $envHomeDir/etc/inputrc
        if [ -x xrdb ] ; then
            xrdb -load $envHomeDir/etc/XDefaults
        fi
        ;;
    *) # non-interactive
        ;;
esac

