#  ---------------------------------------------------------------------------
#
#  Description:  This file contains bash configuration, including aliases
#
#  Sections:
#  1.   Environment Configuration
#  2.   Make Terminal Better (remapping defaults and adding functionality)
#  3.   File and Folder Management
#  4.   Searching
#  5.   Process Management
#  6.   Networking
#  7.   System Operations & Information
#  8.   Web Development
#  9.   Reminders & Notes
#  10.	Sources

#  ---------------------------------------------------------------------------
#  forked from https://github.com/glhaas/bash_profile
#  see also https://natelandau.com/my-mac-osx-bash_profile/

#   ===============================
#   1.  ENVIRONMENT CONFIGURATION
#   -------------------------------

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

	# is this necessary? not even sure what it's doing
	tput init

#	check the window size after each command and, if necessary,
#	update the values of LINES and COLUMNS.
	shopt -s checkwinsize
	# this still doesn't resize prompt

#   Set color variables to simplify changing prompt color for
#	visible differentiation of hosts
#   ------------------------------------------------------------
	BLK='\033[0;30m'	# standard colors
	RED='\033[0;31m'
	GRN='\033[0;32m'
	YLW='\033[0;33m'
	BLU='\033[0;34m'
	MAG='\033[0;35m'
	CYN='\033[0;36m'
	WHT='\033[0;37m'
	BBLK='\033[1;30m'	# bold/intense colors
	BRED='\033[1;31m'
	BGRN='\033[1;32m'
	BYLW='\033[1;33m'
	BBLU='\033[1;34m'
	BMAG='\033[1;35m'
	BCYN='\033[1;36m'
	BWHT='\033[1;37m'
	NC='\033[0m' # No Color

#   Set prompt
#   ------------------------------------------------------------

	# set a prompt without utf-8 characters if in regular xterm
	case "$TERM" in
	    xterm-color|*-256color) fancy_prompt=yes;;
	esac

	if [ "$fancy_prompt" = yes ]; then
		## `(printf "\\u2501%.0s" $(seq 23 $(tput cols)))` prints a line of "━" (i.e. unicode character 2501) that's
		## the width of the terminal window minus 23 chars, which is the length of the
		## date string printed on th right side of the window by `[\D{%F %T}]`.
		## Prompt uses unicode "heavy" box drawings characters 2501 (━), 250F (┏), and 2517 (┗).
		## TRYING THIS NEW VERSION WITHOUT ALL THE ESCAPED [] PAIRS, SEEMS TO WORK FINE?
		PS1="\[${BLU}$(printf "\\u2501%.0s" $(seq 23 $(tput cols))) ${YLW}[\D{%F %T}]\r${BLU}┏━${GRN} \u @ \h ${BLU}━━ ${MAG}\w \]\n\[${BLU}\]┗━━\[${YLW}\] => \[${NC}\]"
		#PS1="\[${BLU}$(printf "\\u2501%.0s" $(seq 23 $(tput cols))) ${YLW}\][\D{%F %T}]\r\[${BLU}\]┏━\[${GRN}\] \u @ \h \[${BLU}\]━━ ${MAG}\w \n\[${BLU}\]┗━━\[${YLW}\] => \[${NC}\]"
		#PS2="\[${BLU}\]━━━\[${YLW}\] => \[${NC}\]"
	else
		PS1="\[${BLU}$(printf "%*s" $(($(tput cols)-22)) "" | sed "s/ /-/g") ${YLW}[\D{%F %T}]\r${GRN}\u@\h${NC}:${MAG}\w ${NC}\]\n\$ "
	fi
	unset fancy_prompt

#this sets title of tab to current running command AND changes bold back to regular for stdout
#trap 'echo -ne "\e]0;"; echo -n $BASH_COMMAND; echo -ne "\007"; printf \\e[0m' DEBUG

#   Set paths
#   ------------------------------------------------------------
    export PATH="/usr/local/sbin:$HOME/bin:$PATH"

#   Set default editor
#   ------------------------------------------------------------
    export EDITOR=/usr/bin/nano
    export VISUAL=/usr/bin/nano

#   Set default blocksize for ls, df, du
#   ------------------------------------------------------------
    export BLOCKSIZE=1k

#   Add color to terminal
#   cf. http://osxdaily.com/2012/02/21/add-color-to-the-terminal-in-mac-os-x/
#   ------------------------------------------------------------
    export CLICOLOR=1
    export LSCOLORS=ExFxBxDxCxegedabagacad

#   also default to color for various commands ('ls' is set below)
#    alias dir='dir --color=auto'
#    alias vdir='vdir --color=auto'
    alias grep='grep --color=always'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

#   ===============================
#   2.  MAKE TERMINAL BETTER
#   -------------------------------

	alias fuckappledns='sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist && sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist'
	alias cp='cp -iv'                           # Preferred 'cp' implementation
	alias mv='mv -iv'                           # Preferred 'mv' implementation
	alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
    alias ls='gls -h --color'                   # Preferred 'ls' implementation; this uses coreutils ls aka gls, which is like linux ls
    #alias ls='ls -Gh'                   		# Preferred 'ls' implementation if coreutils isn't installed
	alias ll='ls -l'                            # More 'ls' fun
    alias la='ls -al'                           # More 'ls' fun
    alias l='ls -CF'                            # More 'ls' fun
    alias l1='ls -1'                            # More 'ls' fun
	alias less='less -FSRXc'                    # Preferred 'less' implementation
	cdd() { builtin cd "$@"; ll; }               # Always list directory contents upon 'cd'
	alias cd..='cd ../'                         # Go up 1 directory level (for fast typers)
	alias ..='cd ../'                           # Go up 1 directory level
	alias ...='cd ../../'                       # Go up 2 directory levels
	alias .3='cd ../../../'                     # Go up 3 directory levels
	alias .4='cd ../../../../'                  # Go up 4 directory levels
	alias .5='cd ../../../../../'               # Go up 5 directory levels
	alias .6='cd ../../../../../../'            # Go up 6 directory levels
	alias edit='subl'                           # edit:         Opens any file in sublime editor
	alias f='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder
	alias ~="cd ~"                              # ~:            Go Home
	alias c='clear'                             # c:            Clear terminal display
	alias which='type -all'                     # which:        Find executables
	alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
	alias show_options='shopt'                  # Show_options: display bash options settings
	alias fix_stty='stty sane'                  # fix_stty:     Restore terminal settings when screwed up
	alias cic='set completion-ignore-case On'   # cic:          Make tab-completion case-insensitive
	mcd () { mkdir -p "$1" && cd "$1"; }        # mcd:          Makes new Dir and jumps inside
	trash () { command mv "$@" ~/.Trash ; }     # trash:        Moves a file to the MacOS trash
	ql () { qlmanage -p "$*" >& /dev/null; }    # ql:           Opens any file in MacOS Quicklook Preview
	alias DT='tee ~/Desktop/terminalOut.txt'    # DT:           Pipe content to file on MacOS Desktop

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash" || true

### ssh
alias ep='ssh root@10.0.10.65'
alias trr='ssh root@10.0.10.66'
alias xe='ssh root@10.0.10.74'
alias sm='ssh root@10.0.10.69'
alias nv='ssh root@10.0.10.70'
alias a8='ssh user@am8'
alias a4='ssh user@am4'
alias sf='ssh user@sfts'
sshh () { ssh user@10.0.10.$1; }

alias lm='ssh user@10.0.10.40'
alias lnn='ssh user@10.0.10.41'

alias naon='nano'

### Disks and block device info
alias dff='df -hT nfs,bindfs,hfs,apfs,exfat,msdos | grep -v timemachine'
alias dffl='df -hl'
alias lss='lsblk -o name,size,fsavail,fsuse%,fstype,uuid,model,mountpoint'

alias bbbash='nano ~/.bash_profile'
alias bsssh='source ~/.bash_profile'
alias baaash='nano ~/.bash_aliases'





#   lr:  Full Recursive Directory Listing
#   ------------------------------------------
	alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

#   mans:   Search manpage given in agument '1' for term given in argument '2' (case insensitive)
#           displays paginated result with colored search terms and two lines surrounding each hit.             Example: mans mplayer codec
#   --------------------------------------------------------------------
    mans () {
        man $1 | grep -iC2 --color=always $2 | less
    }

#   showa: to remind yourself of an alias (given some part of it)
#   ------------------------------------------------------------
    showa () { /usr/bin/grep --color=always -i -a1 $@ ~/Library/init/bash/aliases.bash | grep -v '^\s*$' | less -FSRXc ; }


#   -------------------------------
#   3.  FILE AND FOLDER MANAGEMENT
#   -------------------------------

	zipf () { zip -r "$1".zip "$1" ; }          # zipf:         To create a ZIP archive of a folder
	alias numFiles='echo $(ls -1 | wc -l)'      # numFiles:     Count of non-hidden files in current dir
	alias make1mb='mkfile 1m ./1MB.dat'         # make1mb:      Creates a file of 1mb size (all zeros)
	alias make5mb='mkfile 5m ./5MB.dat'         # make5mb:      Creates a file of 5mb size (all zeros)
	alias make10mb='mkfile 10m ./10MB.dat'      # make10mb:     Creates a file of 10mb size (all zeros)

#   cdf:  'Cd's to frontmost window of MacOS Finder
#   ------------------------------------------------------
    cdf () {
        currFolderPath=$( /usr/bin/osascript <<EOT
            tell application "Finder"
                try
            set currFolder to (folder of the front window as alias)
                on error
            set currFolder to (path to desktop folder as alias)
                end try
                POSIX path of currFolder
            end tell
EOT
        )
        echo "cd to \"$currFolderPath\""
        cd "$currFolderPath"
    }

#   extract:  Extract most known archives with one command
#   ---------------------------------------------------------
    extract () {
        if [ -f $1 ] ; then
          case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
             esac
         else
             echo "'$1' is not a valid file"
         fi
    }


#   ---------------------------
#   4.  SEARCHING
#   ---------------------------

	alias qfind="find . -name "                 # qfind:    Quickly search for file
	ff () { /usr/bin/find . -name "$@" ; }      # ff:       Find file under the current directory
	ffs () { /usr/bin/find . -name "$@"'*' ; }  # ffs:      Find file whose name starts with a given string
	ffe () { /usr/bin/find . -name '*'"$@" ; }  # ffe:      Find file whose name ends with a given string

#   spotlight: Search for a file using MacOS Spotlight's metadata
#   -----------------------------------------------------------
    spotlight () { mdfind "kMDItemDisplayName == '$@'wc"; }


#   ---------------------------
#   5.  PROCESS MANAGEMENT
#   ---------------------------

#   findPid: find out the pid of a specified process
#   -----------------------------------------------------
#       Note that the command name can be specified via a regex
#       E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
#       Without the 'sudo' it will only find processes of the current user
#   -----------------------------------------------------
    findPid () { lsof -t -c "$@" ; }

#   memHogsTop, memHogsPs:  Find memory hogs
#   -----------------------------------------------------
    alias memHogsTop='top -l 1 -o rsize | head -20'
    alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

#   cpuHogs:  Find CPU hogs
#   -----------------------------------------------------
    alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

#   topForever:  Continual 'top' listing (every 10 seconds)
#   -----------------------------------------------------
    alias topForever='top -l 9999999 -s 10 -o cpu'

#   ttop:  Recommended 'top' invocation to minimize resources
#   ------------------------------------------------------------
#       Taken from this macosxhints article
    alias ttop="top -R -F -s 10 -o rsize"

#   my_ps: List processes owned by my user:
#   ------------------------------------------------------------
    my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }


#   ---------------------------
#   6.  NETWORKING
#   ---------------------------

	alias myip='curl -4 icanhazip.com'                  # myip:         Public IP Address
	alias netCons='lsof -i'                             # netCons:      Show all open TCP/IP sockets
	alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
	alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
	alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
	alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
	alias ipInfo0='ipconfig getpacket en0'              # ipInfo0:      Get info on connections for en0
	alias showBlocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs

#   ii:  display useful host related informaton
#   -------------------------------------------------------------------
    ii() {
        echo -e "\nYou are logged on ${RED}$HOST"
        echo -e "\nAdditionnal information:$NC " ; uname -a
        echo -e "\n${RED}Users logged on:$NC " ; w -h
        echo -e "\n${RED}Current date :$NC " ; date
        echo -e "\n${RED}Machine stats :$NC " ; uptime
        echo -e "\n${RED}Current network location :$NC " ; scselect
        echo -e "\n${RED}Public facing IP Address :$NC " ;myip
        #echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
        echo
    }


#   ---------------------------------------
#   7.  SYSTEMS OPERATIONS & INFORMATION
#   ---------------------------------------

	alias mountReadWrite='/sbin/mount -uw /'    # mountReadWrite:   For use when booted into single-user

#   cleanupDS:  Recursively delete .DS_Store files
#   -------------------------------------------------------------------
    alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"

#   finderShowHidden:   Show hidden files in Finder
#   finderHideHidden:   Hide hidden files in Finder
#   -------------------------------------------------------------------
    alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'
    alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'

#   cleanupLS:  Clean up LaunchServices to remove duplicates in the "Open With" menu
#   -----------------------------------------------------------------------------------

#    screensaverDesktop: Run a screensaver on the Desktop
#   -----------------------------------------------------------------------------------
    alias screensaverDesktop='/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine -background'

#   ---------------------------------------
#   8.  WEB DEVELOPMENT
#   ---------------------------------------

	alias apacheEdit='sudo edit /etc/httpd/httpd.conf'      # apacheEdit:       Edit httpd.conf
	alias apacheRestart='sudo apachectl graceful'           # apacheRestart:    Restart Apache
	alias editHosts='sudo edit /etc/hosts'                  # editHosts:        Edit /etc/hosts file
	alias herr='tail /var/log/httpd/error_log'              # herr:             Tails HTTP error logs
	alias apacheLogs="less +F /var/log/apache2/error_log"   # Apachelogs:   Shows apache error logs
	httpHeaders () { /usr/bin/curl -I -L $@ ; }             # httpHeaders:      Grabs headers from web page

#   httpDebug:  Download a web page and show info on what took time
#   -------------------------------------------------------------------
    httpDebug () { /usr/bin/curl $@ -o /dev/null -w "dns: %{time_namelookup} connect: %{time_connect} pretransfer: %{time_pretransfer} starttransfer: %{time_starttransfer} total: %{time_total}\n" ; }


#   ===============================
#   9.  REMAINDERS & NOTES
#   -------------------------------

#   to change the password on an encrypted disk image:
#   ---------------------------------------
#   hdiutil chpass /path/to/the/diskimage

#   to mount a read-only disk image as read-write:
#   ---------------------------------------
#   hdiutil attach example.dmg -shadow /tmp/example.shadow -noverify

#   mounting a removable drive (of type msdos or hfs)
#   ---------------------------------------
#   mkdir /Volumes/Foo
#   ls /dev/disk*   to find out the device to use in the mount command)
#   mount -t msdos /dev/disk1s1 /Volumes/Foo
#   mount -t hfs /dev/disk1s1 /Volumes/Foo

#   <--------------------------------------->
#   RE/MOVED

#   AWS servers
#alias shell-poc-jumpbox=
#alias shell-gitlab=

#   ===============================
#	10.  SOURCES
#   -------------------------------

#   sources for some of the things here not in original gist (https://github.com/glhaas/bash_profile)
#	https://stackoverflow.com/a/21368867/14974911		# PS1 width expand


# ### Pretty colors
# if [ -x /usr/bin/dircolors ]; then
#     test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
# fi

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
export PATH="/usr/local/opt/berkeley-db@4/bin:$PATH"
