#  ---------------------------------------------------------------------------
#
#  Description:  Andy's customized .bash_profile
#
#  Resources/References:
#  https://gist.github.com/natelandau/10654137
#  http://www.marinamele.com/2014/05/customize-colors-of-your-terminal-in-mac-os-x.html
#  defaults write -app Calculator AppleLanguages -array de
#  defaults read -g AppleLanguages
#
#  ---------------------------------------------------------------------------

#   Sourcing
#   ------------------------------------------------------------
if [ -f $(brew --prefix)/etc/bash_completion ]; then
	. $(brew --prefix)/etc/bash_completion
fi

#   Change Prompt
#   ------------------------------------------------------------
export PS1="\u@\w$ "
export PS2="> "

#   Add Colour
#   ------------------------------------------------------------
export CLICOLOR="1"
export LSCOLORS="bxxxCxDxBxxxxxxxxxxxxx"

#   Set Paths
#   ------------------------------------------------------------
export GOPATH="$HOME/Workspace/GoProjects"
export PATH="$PATH:$GOPATH/bin"

#   Set Default Editor
#   ------------------------------------------------------------
export EDITOR="subl"

#  Currently working on projects/Directory navigation
#  ------------------------------------------------------------
alias bpro="subl ~/.bash_profile"
alias new="open -a Terminal '$HOME'"
docs() { cd ~/Documents/; }

#   -------------------------------
#     ALIASES
#   -------------------------------

#   Version Aliases
#   ------------------------------------------------------------
alias pip='pip3'
alias python='python3'

#   Basic Aliases Preferences
#   ------------------------------------------------------------
alias ls='ls -Gp'                           # Preferred ‘ls’ implementation
alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias lsa='ls -aGp'							# List all
alias lss='du -sh *'
alias ll='ls -FGlAhp'                      # List with a bunch of tags
alias less='less -FSRXc'                    # Preferred 'less' implementation
alias diff='colordiff'
alias ftp='lftp'
alias top='htop'
alias meld='open -W -a Meld'

#   Directory Aliases
#   ------------------------------------------------------------
cd() { builtin cd "$@"; ls; }               # Always list directory contents upon 'cd'
alias back='cd ../'                         # Go back 1 directory level
alias cd..='cd ../'                         # Go back 1 directory level
alias cd...='cd ../../'                     # Go back 2 directory levels
alias cd....='cd ../../../'                 # Go back 3 directory levels
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias ....='cd ../../'                      # Go back 3 directory levels
alias .2='cd ../../'                        # Go back 2 directory levels
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels
alias ~="cd ~"                              # ~: Go Home


#   Other Aliases
#   ------------------------------------------------------------
alias edit='subl'                        # edit:         Opens any file in sublime editor
alias finder='open -a Finder ./'            # f:            Opens current directory in MacOS Finder
alias which='type -all'                     # which:        Find executables
alias path='echo -e ${PATH//:/\, }'         # path:         Echo all executable Paths
alias show_options='shopt'                  # Show_options: display bash options settings
alias fix_terminal='stty sane'              # fix_stty:     Restore terminal settings when screwed up
alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete" 
                                            #cleanupDS:     Cleanup .DS_store recursively
alias mvscreenshots="mv ~/Desktop/*.png ~/Pictures/Screenshots/"
                                            #mvscreenshots: Move all screenshots on desktop to screenshot folder
alias listallapp="sudo find / -iname *.app"
alias sizeof="du -hs"

#   Network Aliases
#   ------------------------------------------------------------
alias networkstatus='netstat -an -f inet -p tcp | grep LISTEN' 
                                            #networkstatus  Show network statuses

#   -------------------------------
#     FUNCTIONS
#   -------------------------------

# zipf:  creates a ZIP archive of a folder
# ---------------------------------------------------------
zipf () {
    zip -r "$1".zip "$1"
}

# trash:  Move a folder or file to the trash
# ---------------------------------------------------------
trash () {
    echo -e "\e[31m'${@}' has been trashed.\e[0m"
    command mv "$@" ~/.Trash
}

# ql:  Opens file in MacOS Quicklook Preview
# ---------------------------------------------------------
ql () {
    qlmanage -p "$*" >& /dev/null
}

# randpassw:  Generates a random password
# ---------------------------------------------------------
randpassw() {
    if [ -z $1 ]; then
        MAXSIZE=10
    else
        MAXSIZE=$1
    fi
    array1=( 
        q w e r t y u i o p a s d f g h j k l z x c v b n m Q W E R T Y U I O P A S D 
        F G H J K L Z X C V B N M 1 2 3 4 5 6 7 8 9 0 
        \! \@ \$ \% \^ \& \* \! \@ \$ \% \^ \& \* \@ \$ \% \^ \& \* 
        ) 
    MODNUM=${#array1[*]} 
    pwd_len=0 
    while [ $pwd_len -lt $MAXSIZE ] 
    do 
    index=$(($RANDOM%$MODNUM)) 
    echo -n "${array1[$index]}" 
    ((pwd_len++)) 
	done 
	echo 
}

# mcd:  akes new Dir and jumps inside
# ---------------------------------------------------------
mkcd () { 
    mkdir -p "$1" && cd "$1"
} 

# chrome:  Open in chrome
# ---------------------------------------------------------
chrome() {
    open -a "Google Chrome" $@
}

# safari:  Open in safari
# ---------------------------------------------------------
safari() {
    open -a "Safari" $@
}

# markdown:  Open in macdown
# ---------------------------------------------------------
macdown() {
    open -a "MacDown" $@
}

# killport: kills the port you specify
# ---------------------------------------------------------
killport() {
    echo -e "\e[31mPort '${1}' has been killed.\e[0m"
    lsof -i TCP:$1 | awk '/LISTEN/ {print $2}' | xargs kill -9 
}

# findfile: find the file you specify
# ---------------------------------------------------------
findfile() {
	find . -type f -name "$1"
}

# finddir: find the directory you specify
# ---------------------------------------------------------
finddir() {
	find . -type d -name "$1"
}

# grepline: find a pattern recursively in all files
# ---------------------------------------------------------
grepline() {
    grep -rni "$@" .
}

# changelanguage: change the language of an application
# ---------------------------------------------------------
changelanguage() {
    defaults write -app "$1" AppleLanguages -array "$2"
    defaults read -g AppleLanguages
}

# cdf: cd to the path of the front Finder window
# ----------------------------------------------------------
cdf() {
    target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
    if [ "$target" != "" ]; then
        cd "$target"; pwd
    else
        echo 'No Finder window found' >&2
    fi
}