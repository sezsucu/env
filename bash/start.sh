#@IgnoreInspection BashAddShebang
# unfortunately because of a bug I had to disable, keep it for debugging
# set -u

# find where we are installed at
INSTALL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export ENV_HOME_DIR=`dirname $INSTALL_DIR` # where env is installed at
export ENV_DATA_DIR=$HOME/.envData # the data directory
if [ ! -d $ENV_DATA_DIR ]; then
    mkdir $ENV_DATA_DIR
    mkdir $ENV_DATA_DIR/bash # history file
    mkdir $ENV_DATA_DIR/ssh # authorized_keys file
    mkdir $ENV_DATA_DIR/emacs
    mkdir $ENV_DATA_DIR/emacs/backup # emacs backup files
    touch $ENV_DATA_DIR/bash/bashVars.sh # host variables for convenience
fi

#export envHasPython=`command -v python3`

# custom settings
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
# functions, support stuff (lib should come before aliases)
source $ENV_HOME_DIR/bash/lib.sh
# aliases
source $ENV_HOME_DIR/bash/aliases.sh
# host variables in the form of web='web.test.com', so you can ssh $web
source $ENV_DATA_DIR/bash/bashVars.sh;


# [Other Environment Variables]
export TZ=Etc/UTC # use UTC by default everywhere
export PAGER=less
export LESSCHARSET='utf-8'
export TMOUT=0 # never logout due to inactivity

# [History]
export HISTFILE=$ENV_DATA_DIR/bash/history
export HISTSIZE=10000
export HISTIGNORE="&:bg:fg:lsl:lsll:lsa:ls:history:exit"
export HISTCONTROL="ignoreboth"
shopt -s histappend # append to the history file, rather than overwrite it
shopt -s histreedit
shopt -s histverify # allow me to edit the old command

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
if [ `command -v git` ]; then
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
        PS1="\n\[$Blue\]\u\[$NC\][\t]:\[$BlackBG\]\[$White\]\w \[$NC\]\n% "
            ;;
        *)
            PS1="\n\[$Blue\]\u\[$NC\][\t]:\[$BlackBG\]\[$White\]\w \[$NC\]\n% "
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


