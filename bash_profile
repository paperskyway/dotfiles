#  ---------------------------------------------------------------------------
#
#  Andy's customized .bash_profile
#
#  ---------------------------------------------------------------------------

#   Change Prompt
#   ------------------------------------------------------------
export PS1="\u@\w$ "
export PS2="> "

#   Add Colour
#   http://www.marinamele.com/2014/05/customize-colors-of-your-terminal-in-mac-os-x.html
#   http://www.bigsoft.co.uk/blog/index.php/2008/04/11/configuring-ls_colors
#   ------------------------------------------------------------
export CLICOLOR="1"
# export LSCOLORS="gxGxxxxxbxxCxCxCxCgxgx" # Cyan
export LSCOLORS="exExxxxxbxxGxGxGxGexex" # Blue
# export LSCOLORS="bxBxxxxxExxGxGxGxGbxbx" # Red
# export LS_COLORS="fi=00:di=34:ln=01;34:pi=00:do=00:bd=00:cd=00:or=00:so=00:su=00:sg=00:tw=00:ow=34:st=34:ex=31" # Blue
export LS_COLORS="fi=00:di=96:ln=01;96:pi=00:do=00:bd=00:cd=00:or=00:so=00:su=00:sg=00:tw=00:ow=96:st=96:ex=34;01" # Turquoise
# export LS_COLORS="fi=00:di=31:ln=01;31:pi=00:do=00:bd=00:cd=00:or=00:so=00:su=00:sg=00:tw=00:ow=31:st=31:ex=34;01" # Red

#   Sourcing
#   ------------------------------------------------------------
if [ -f ~/dotfiles/.aliases ]; then
    . ~/dotfiles/.aliases
fi

if [ -f $(brew --prefix)/etc/bash_completion ]; then
	. $(brew --prefix)/etc/bash_completion
fi

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
eval $(/usr/libexec/path_helper -s)
