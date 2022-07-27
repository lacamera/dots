#!/bin/ksh
. "$HOME/.config/env"
. "$HOME/.config/aliases"

HISTFILE="$HOME/.cache/ksh_history"
HISTSIZE=65536
set -o vi

_reset() { printf "%s" "\e[0;00m"; }
_green() { printf "%s" "\e[0;32m"; }
_red() { printf "%s" "\e[0;91m"; }
_blue() { printf "%s" "\e[0;34m"; }
_yellow() { printf "%s" "\e[0;33m"; }

_pwd() {
	p="$(pwd | sed "s,^$HOME,~," | rev | cut -d'/' -f 1-2 | rev)"
	_yellow; printf "%s" "$p"; _reset
}

_git() {
	 if [ "$(git -C "$PWD" rev-parse 2> /dev/null; echo $?)" -eq 0 ]; then
		branch="$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/' -e 's/(//g' -e 's/)//g')"
		printf "~"; _red; printf "%s" "$branch"; _reset;
	fi
}

_ssh() {
	client=0
	hn=`hostname -s`
	if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
		client=1
	else
		case $(ps -o comm= -p "$PPID") in
			sshd|*/sshd) client=1;;
		esac
	fi

	if [[ "$client" -eq 1 ]]; then
		printf "@"; _blue; printf "%s" "$hn "; _reset;
	fi
}

PS1="\u:\$(_pwd)\$(_git) \$(_ssh)\$ "
