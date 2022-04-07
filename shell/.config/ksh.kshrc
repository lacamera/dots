# ksr.kshrc -- commands executed by each (pd)ksh at startup
HISTFILE="$HOME/.cache/ksh_history"
HISTSIZE=4096
set -o vi

. "$HOME/.config/env"

_git_branch() {
	 if [ "$(git -C "$PWD" rev-parse 2> /dev/null; echo $?)" -eq 0 ]; then
		branch="$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/' -e 's/(//g' -e 's/)//g')"
		printf " $branch"
	fi
}

_ssh_status() {
	SSH=0
	if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
		SSH=1
	else
		case $(ps -o comm= -p "$PPID") in
		sshd|*/sshd) SSH=1;;
	esac
	fi

	[[ "$SSH" -eq 1 ]] && printf " ssh"
}

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

PS1="[\u@\h:\$(_col_green)\w\$(_col_reset)\$(_col_blue)\$(_ssh_status)\$(_col_red)\$(_git_branch)\$(_col_reset)]\n\$(_col_yellow)\$ \$(_col_reset)"
