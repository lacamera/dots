#!/bin/ksh
# ksr.kshrc -- commands executed by each (pd)ksh at startup
HISTFILE="$HOME/.cache/ksh_history"
HISTSIZE=4096
set -o vi

_col_reset() {
	printf "\e[0;00m"
}

_col_green() {
	printf "\e[0;32m"
}

_col_red() {
	printf "\e[0;91m"
}

_col_blue() {
	printf "\e[0;34m"
}

_col_yellow() {
	printf "\e[0;33m"
}

_ps_pwd() {
	_pwd="$(pwd | sed 's,^$HOME,~,' | rev | cut -d'/' -f 1-2 | rev)"
	_col_yellow
	printf "$_pwd"
	_col_reset
}

_ps_ssh() {
	SSH=0
	if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
		SSH=1
	else
		case $(ps -o comm= -p "$PPID") in
		sshd|*/sshd) SSH=1;;
	esac
	fi

	if [[ "$SSH" -eq 1 ]]; then
		_col_blue
		printf "ssh"
		_col_reset
		_ps_sep
	fi
}
_ps_git() {
	 if [ "$(git -C "$PWD" rev-parse 2> /dev/null; echo $?)" -eq 0 ]; then
		branch="$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/' -e 's/(//g' -e 's/)//g')"
		_col_red
		printf "$branch"
		_col_reset
	fi
}

_ps_sep() {
	printf ":"
}

PS1="\$(_ps_ssh)\h \$(_ps_pwd) \$(_ps_git)\n\$ "
