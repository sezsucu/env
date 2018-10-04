# [Aliases]
# to sanitize the terminal
alias sane="stty sane"

# delete all emacs stuff in the current dir
alias edel='\rm *~'

# to reread this file from the shell
alias resetShell=". $envHomeDir/bash/start.sh"

# easier navigation
alias cd..="cd .."
alias ..="cd .."

# disk usage
alias dus='du -sh'

#displays top 15 largest files
#alias largeFiles='find . -ls | sort -nrk7 | head -15'
alias largeFiles='find . -ls | awk "{printf \$7; \$1 = \"\"; \$2 = \"\"; \$3 = \"\"; \$4 = \"\"; \$6 = \"\"; \$7 = \"\"; print \$0;}" | sort -nr | tr -s " " | head -15 | awk "function toDisplay(x) { split( \"b K M G T\", v ); s = 1; while( x >= 1024 ){ x /= 1024; s++; } return sprintf(\"%d%s\", int(x), v[s]); } {printf toDisplay(\$1); \$1 = \"\"; print \$0;}" '

# make sure we don't mess things up
alias cp='cp -i'
alias rm='rm -i'
alias mv='mv -i'
alias rmf='rm -rf'

# process management
alias ps='ps aux'
alias pg='ps | grep -i'

#paths
alias paths='echo -e ${PATH//:/\\n}'
alias libpaths='echo -e ${LD_LIBRARY_PATH//:/\\n}'
# programs
alias emacs='emacs --load ${envHomeDir}/etc/emacs/config.el'

alias localDate='TZ=$LOCAL_TIME_ZONE date  "+$ISO_DATE_FMT"'
alias utcDate='TZ=Etc/UTC date -u "+$ISO_DATE_FMT"'
alias localTime='TZ=$LOCAL_TIME_ZONE date  "+%H:%M:%S"'

# display pid too
alias jobs='jobs -l'
# display idle time and the associated pid
alias who='who -u'

if [ `command -v curl` ]; then
    alias download='curl -L -C - -O --retry 5'
    alias responseHeaders='curl -D - -so /dev/nul'
    alias allHeaders='curl -v -so /dev/nul'
elif [ `command -v wget` ]; then
    alias download='wget'
else
    alias download='echo "No wget or curl found"'
fi

