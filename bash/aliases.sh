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
#alias largeFiles='find . -ls | awk "{$1=''; $2='' print \$7, \$5, \$8, \$9, \$10; for(i=11;i<NF;i++){ printf " %s", \$i }}" | sort -nr | head -15'
alias largeFiles='find . -ls | awk "{printf \$7; \$1 = \"\"; \$2 = \"\"; \$3 = \"\"; \$4 = \"\"; \$6 = \"\"; \$7 = \"\"; print \$0;}" | tr -s " "  | sort -nr | head -15 '
#alias largeDirs='du -S . | sort -nr | head -15'

# make sure we don't mess things up
alias cp='cp -i'
alias rm='rm -i'
alias mv='mv -i'
alias rmf='rm -rf'

# process management
alias ps='ps aux'
alias pg='ps | grep -i'

#paths
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'
# programs
alias emacs='emacs --load ${envHomeDir}/etc/emacs/config.el'

alias date_here='TZ=$LOCAL_TIME_ZONE date  "+$ISO_DATE_FMT"'
alias date_utc='TZ=Etc/UTC date -u "+$ISO_DATE_FMT"'
alias time_here='TZ=$LOCAL_TIME_ZONE date  "+%H:%M:%S"'
