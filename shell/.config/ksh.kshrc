# ksr.kshrc -- commands executed by each (pd)ksh at startup
HISTFILE="$HOME/.cache/ksh_history"
HISTSIZE=4096

set -o vi

export EDITOR="nvim"
export BROWSER="firefox"
export READER="zathura"

alias ls="colorls -G"
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias vim="nvim"
alias tmux="tmux -uf ~/.config/tmux.conf"
alias s="dwmswallow $WINDOWID;"
alias ga="git add ."
alias gc="git commit -m"
alias gl="git log --oneline --graph"
alias gs="git status -s"
alias pfs="pfctl -ss"
alias pfr="pfctl -sr"

_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/' -e 's/(//g' -e 's/)//g'
}

PS1="[\u@\h:\[\e[32m\]\w\[\e[00m\]] [\[\e[91m\]\$(_git_branch)\[\e[00m\]]\n\e[33m\]\$\e[00m\] "
