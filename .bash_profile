	# ------------------------------------------------------------
	# Description:	This file contains bash configuration, aliases, and commands
	# 				to enhance MacOS Terminal.

	# Sections:
	# 1.	Environment Configuration
	# 2.	Terminal Configuration (adds aliases and additional functionality)
	# 3.	File and Folder Management
	# 4.	Searching
	# 5.	Process Management
	# 6.	Networking
	# 7.	System Operations & Information
	# 8.	Web Development
	# 9.	Reminders, Notes, & Sources


	# =======================================
	# 1.	ENVIRONMENT CONFIGURATION
	# ---------------------------------------

	# If not running interactively, don't do anything
	case $- in
		*i*);;
		  *) return;;
	esac

	# Set color variables to simplify displaying prompt colors
	# ------------------------------------------------------------
	# standard colors
	BLK='\033[0;30m'; RED='\033[0;31m'; GRN='\033[0;32m'; YLW='\033[0;33m'
	BLU='\033[0;34m'; MAG='\033[0;35m'; CYN='\033[0;36m'; WHT='\033[0;37m'
	# bold/intense colors
	BBLK='\033[1;30m'; BRED='\033[1;31m'; BGRN='\033[1;32m'; BYLW='\033[1;33m'
	BBLU='\033[1;34m'; BMAG='\033[1;35m'; BCYN='\033[1;36m'; BWHT='\033[1;37m'
	# No Color
	NC='\033[0m'

	# Set prompt
	# ------------------------------------------------------------
	tput init
	unset fancy_prompt
	# Avoid UTF-8 characters unless in terminal that supports them
	case "$TERM" in
		xterm-color|*-256color) fancy_prompt=yes;;
	esac

	# `(printf "\\u2501%.0s" $(seq 23 $(tput cols)))` prints unicode char 2501 for width of terminal window (`tput cols`)
	#  minus 23 (length of string printed on right by `[\D{%F %T}]`). Uses unicode heavy box drawings chars 2501 (━), 250F (┏), and 2517 (┗). 
	if [ "$fancy_prompt" = yes ]; then
		PS1="${BLU}$(printf "\\u2501%.0s" $(seq 23 $(tput cols))) ${YLW}[\D{%F %T}]\r${BLU}┏━${GRN} \u @ \h ${BLU}━━ ${CYN}\w \n\[${BLU}\]┗━━\[${YLW}\] =>\\$ \[${NC}\]"
 		PS2="\[${BLU}\]┗━━\[${YLW}\] =>\\$ \[${NC}\]"
	else
		# Set a prompt without UTF-8 characters in regular xterm
		PS1="\[${BLU}$(printf "%*s" $(($(tput cols)-22)) "" | sed "s/ /-/g") ${YLW}[\D{%F %T}]\r${GRN}\u@\h${NC}:${MAG}\w ${NC}\]\n\$ "
	fi

	# Set paths
	# ------------------------------------------------------------
	export PATH="/usr/local/sbin:$HOME/bin:$PATH"

	# Set default editor
	# ------------------------------------------------------------
	export EDITOR=/usr/bin/nano
	export VISUAL=/usr/bin/nano

	# Set default blocksize for ls, df, du
	# ------------------------------------------------------------
	export BLOCKSIZE=1k

	# Add color to terminal
	# cf. http://osxdaily.com/2012/02/21/add-color-to-the-terminal-in-mac-os-x/
	# ------------------------------------------------------------
	export CLICOLOR=1
	export LSCOLORS=ExFxBxDxCxegedabagacad

	# Set *LS_COLORS* (note the underscore), which is used by GNU coreutils gls
	if [ -x /usr/local/bin/gdircolors ]; then
		test -r ~/.dircolors && eval "$(gdircolors -b ~/.dircolors)" || eval "$(gdircolors -b)"
	fi

	# Source additional aliases and environment variables
	# ------------------------------------------------------------
	[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
	test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash" || true
	source ~/.bash_aliases

	# =======================================
	# 2.	TERMINAL CONFIGURATION
	# ---------------------------------------

	alias cp='cp -v'							# Preferred 'cp' configuration
	alias mv='mv -v'							# Preferred 'mv' configuration
	alias mkdir='mkdir -pv'						# Preferred 'mkdir' configuration
	alias ll='ls -l'							# More 'ls' fun
	alias la='ls -al'							# More 'ls' fun
	alias l='ls -CF'							# More 'ls' fun
	alias l1='ls -1'							# More 'ls' fun
	alias less='less -FSRXc'					# Preferred 'less' configuration
	cdd() { builtin cd "$@"; ll; }				# Always list directory contents upon 'cd'
	alias cd..='cd ../'							# Go up 1 directory level (for fast typers)
	alias ..='cd ../'							# Go up 1 directory level
	alias ...='cd ../../'						# Go up 2 directory levels
	alias .3='cd ../../../'						# Go up 3 directory levels
	alias .4='cd ../../../../'					# Go up 4 directory levels
	alias .5='cd ../../../../../'				# Go up 5 directory levels
	alias .6='cd ../../../../../../'			# Go up 6 directory levels
	alias edit='subl'							# Open any file in sublime editor
	alias f='open -a Finder ./'					# Open current directory in MacOS Finder
	alias ~="cd ~"								# Go $HOME
	alias c='clear'								# Clear terminal display
	alias which='type -all'						# Find executables
	alias path='echo -e ${PATH//:/\\n}'			# Echo all executable Paths
	alias showoptions='shopt'					# Show_options: display bash options settings
	alias fix_stty='stty sane'					# Restore terminal settings when screwed up
	alias cic='set completion-ignore-case On'	# Make tab-completion case-insensitive
	mcd () { mkdir -p "$1" && cd "$1"; }		# Make new directory go to it
	trash () { command mv "$@" ~/.Trash ; }		# Move a file to the MacOS trash
	ql () { qlmanage -p "$*" >& /dev/null; }	# Open file in MacOS Quicklook Preview
	alias DT='tee ~/Desktop/terminalOut.txt'	# Pipe content to file on MacOS Desktop

	# Use coreutils gls if available (closer to Linux implementation of ls)
	# ------------------------------------------------------------
	if [[ $(which gls) ]]; then 
		alias ls='gls -h --color'
	else 
		alias ls='ls -Gh'
	fi
	
	# Default to color for various commands (color for `ls` is set agove)
	# ------------------------------------------------------------
	alias dir='dir --color=auto'
	alias vdir='vdir --color=auto'
	alias grep='grep --color=always'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'

	# Compensate for typos
	# ------------------------------------------------------------
	alias naon='nano'

	# Customize disk/block device listings
	# ------------------------------------------------------------
	alias dff='df -hT nfs,bindfs,hfs,apfs,exfat,msdos | grep -v timemachine'
	alias dffl='df -hl'
	alias lss='lsblk -o name,size,fsavail,fsuse%,fstype,uuid,model,mountpoint'

	# Simplify modifying this profile
	# ------------------------------------------------------------
	alias bbbash='nano ~/.bash_profile'
	alias bsssh='source ~/.bash_profile'
	alias baaash='nano ~/.bash_aliases'

	# Full Recursive Directory Listing
	# ------------------------------------------------------------
	alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

	# Search a command's manpage and display paginated results, with colored search terms and two lines surrounding each hit.
	# Use:	 	mans <command> <search term (case insensitive)>
	# Example:	mans mplayer codec
	# ------------------------------------------------------------
	mans () {
		man $1 | grep -iC2 --color=always $2 | less
	}

	# Search for an alias
	# Use: 		showa <some part of alias name>
	# Example:	showa mkd
	# ------------------------------------------------------------
	showa () { /usr/bin/grep --color=always -i -a1 $@ ~/Library/init/bash/aliases.bash | grep -v '^\s*$' | less -FSRXc ; }

	# =======================================
	# 3.	FILE AND FOLDER MANAGEMENT
	# ---------------------------------------

	zipf () { zip -r "$1".zip "$1" ; }			# Create a ZIP archive of a folder
	alias numFiles='echo $(ls -1 | wc -l)'		# Count non-hidden files in current dir
	alias make1mb='mkfile 1m ./1MB.dat'			# Create a 1MB file (all zeros)
	alias make5mb='mkfile 5m ./5MB.dat'			# Create a 5MB file (all zeros)
	alias make10mb='mkfile 10m ./10MB.dat'		# Create a 10MB file (all zeros)

	# Change terminal directory to the directory in the frontmost window of MacOS Finder
	# ------------------------------------------------------------
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

	# Extract most known archives
	# ------------------------------------------------------------
	extract () {
		if [ -f $1 ] ; then
			case $1 in
			*.tar.bz2)	tar xjf $1;;
			*.tar.gz)	tar xzf $1;;
			*.bz2)		bunzip2 $1;;
			*.rar)		unrar e $1;;
			*.gz)		gunzip $1;;
			*.tar)		tar xf $1;;
			*.tbz2)		tar xjf $1;;
			*.tgz)		tar xzf $1;;
			*.zip)		unzip $1;;
			*.Z)		uncompress $1;;
			*.7z)		7z x $1;;
			*)		echo "'$1' cannot be extracted via extract()";;
			esac
		else
			echo "'$1' is not a valid file"
		fi
	}

	# =======================================
	# 4.	SEARCHING
	# ---------------------------------------

	alias qfind="find . -name "					# Quickly search for file
	ff () { /usr/bin/find . -name "$@" ; }		# Find file under the current directory
	ffs () { /usr/bin/find . -name "$@"'*' ; }	# Find file whose name starts with a given string
	ffe () { /usr/bin/find . -name '*'"$@" ; }	# Find file whose name ends with a given string

	# Search for a file using MacOS Spotlight metadata
	# ------------------------------------------------------------
	spotlight () { mdfind "kMDItemDisplayName == '$@'wc"; }

	# =======================================
	# 5.	PROCESS MANAGEMENT
	# ---------------------------------------

	# Get the pid of a process by name
	# ------------------------------------------------------------
	# 	Note that the command name can be specified via regex
	# 	E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
	# 	Without the 'sudo' it will only find processes of the current user
	# ------------------------------------------------------------
	findPid () { lsof -t -c "$@" ; }

	# Show memory hogs
	# ------------------------------------------------------------
	alias memHogsTop='top -l 1 -o rsize -ncols 20 -n 10'
	alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

	# Show CPU hogs
	# ------------------------------------------------------------
	alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

	# Continual 'top' listing (every 3 seconds)
	# ------------------------------------------------------------
	alias topForever='top -l 0 -s 3 -n 70 -o cpu -ncols 30'

	# Recommended 'top' invocation to minimize resources
	# ------------------------------------------------------------
	alias ttop="top -R -F -s 5 -o rsize"

	# List processes owned by current user:
	# ------------------------------------------------------------
	my_ps() { ps $@ -u $USER -ro pid,%cpu,%mem,start,time,bsdtime,command | less; }

	# =======================================
	# 6.	NETWORKING
	# ---------------------------------------

	alias myip='curl -4 icanhazip.com'					# Show public IP Address
	alias netCons='lsof -i'								# Show all open TCP/IP sockets
	alias flushDNS='sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist && 
		sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist'							# Flush DNS Cache
	alias fuckappledns='sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist && 
		sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist'							# Flush DNS Cache
	alias lsock='sudo /usr/sbin/lsof -i -P'				# Display open sockets
	alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'	# Display only open UDP sockets
	alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'	# Display only open TCP sockets
	ipInfo () { ipconfig getpacket en"$1"; }			# Get info on connections for enX network interface

	# Display useful host related informaton
	# ------------------------------------------------------------
	ii() {
		echo -e "\nYou are logged on ${CYN}$HOST"
		echo -e "\nAdditional information:$NC " ; uname -a
		echo -e "\n${CYN}Active user sessions:$NC " ; w -h
		echo -e "\n${CYN}Current date:$NC " ; date
		echo -e "\n${CYN}Machine stats:$NC " ; uptime
		echo -e "\n${CYN}Current system configuration \"location\":$NC " ; scselect
		echo -e "\n${CYN}Public IP Address:$NC " ; myip
		echo -e "\n${CYN}DNS configuration (partial):$NC " ; scutil --dns | (head;tail)
		echo
	}

	# =======================================
	# 7.	SYSTEMS OPERATIONS & INFORMATION
	# ---------------------------------------

	# Recursively delete .DS_Store files
	# ------------------------------------------------------------
	alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"

	# Show/hide hidden files in Finder (can also be done with ⌘ + . )
	# ------------------------------------------------------------
	alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'
	alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'

	# Run a screensaver on the Desktop
	# ------------------------------------------------------------
	alias screensaverDesktop='/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine -background'

	# =======================================
	# 8.	WEB DEVELOPMENT
	# ---------------------------------------

	alias apacheEdit='sudo edit /etc/httpd/httpd.conf'		# Edit httpd.conf
	alias apacheRestart='sudo apachectl graceful'			# Restart Apache
	alias editHosts='sudo edit /etc/hosts'					# Edit /etc/hosts
	alias herr='tail /var/log/httpd/error_log'				# Tail HTTP error logs
	alias apacheLogs="less +F /var/log/apache2/error_log"	# Show Apache error logs
	httpHeaders () { /usr/bin/curl -I -L $@ ; }				# Get web page headers

	# Download a web page and show info on what took time
	# ------------------------------------------------------------
	httpDebug () { /usr/bin/curl $@ -o /dev/null -w \
	"dns: %{time_namelookup} connect: %{time_connect} pretransfer: %{time_pretransfer} starttransfer: %{time_starttransfer} total: %{time_total}\n" ; }

	# =======================================
	# 9.	REMINDERS, NOTES, SOURCES
	# ---------------------------------------

	# to change the password on an encrypted disk image:
	# ------------------------------------------------------------
	# hdiutil chpass /path/to/the/diskimage

	# to mount a read-only disk image as read-write:
	# ------------------------------------------------------------
	# hdiutil attach example.dmg -shadow /tmp/example.shadow -noverify

	# to mount a removable drive (of type msdos or hfs)
	# ------------------------------------------------------------
	# sudo mkdir /Volumes/Foo
	# ls /dev/disk*	(to find the device to mount)
	# mount -t msdos /dev/disk1s1 /Volumes/Foo
	# mount -t hfs /dev/disk1s1 /Volumes/Foo

	# check the window size after each command and, if necessary,
	# update the values of LINES and COLUMNS.
	# shopt -s checkwinsize
	# removing because per bash manpage, enabled by default
	# this still doesn't resize prompt

	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# forked from https://github.com/glhaas/bash_profile
	# see also (?) https://natelandau.com/my-mac-osx-bash_profile/

	# sources for some new additions
	# https://stackoverflow.com/a/21368867/14974911		# PS1 with variable-width prompt
	# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
