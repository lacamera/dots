# .kshrc -- commands executed by each (pd)ksh at startup
# @(#)PD KSH v5.2.14 99/07/13.2

HISTFILE="$HOME/.cache/ksh_history"
HISTSIZE=4096

export EDITOR="nvim"

alias vim="nvim"
alias tmux="tmux -uf ~/.config/tmux.conf"
alias s="dwmswallow $WINDOWID;"

set -o vi
PS1="\u@\h:\$PWD \n\$ "

