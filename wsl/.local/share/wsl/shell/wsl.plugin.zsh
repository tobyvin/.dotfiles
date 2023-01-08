#!/bin/sh
# shellcheck disable=2155

alias wsl="/mnt/c/Windows/system32/wsl.exe"
alias powershell="/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"
alias pwsh="/mnt/c/Program Files/PowerShell/7/pwsh.exe"
alias ykman='/mnt/c/Program\ Files/Yubico/YubiKey\ Manager/ykman.exe'

wsl_path() {
    win_path="$(powershell.exe "(get-command $1 -ErrorAction SilentlyContinue).Source")"
    if [ ! -z "$win_path" ]; then
        echo "$(wslpath "$win_path" | sed 's/\s/\\\ /g' | sed 's/\\\s*$//')"
    fi
}

alias pwsh="$(wsl_path "pwsh")"
alias ykhold='sudo systemctl stop usbip@wsl.service && echo "Press any key..." && read && sudo systemctl start usbip@wsl.service'

wsl_cmd_proxy() {
	exe="$1"
	shift # past exe

	cmd=" ${1}"
	shift # past cmd

	args=""
	while [ $# -gt 0 ]; do
		case "$1" in
		-*)
			args="$args${1} '${2}' "
			shift
			shift
			;;
		*)
			args="$args'${1}'"
			shift
			;;
		esac
		args="$args "
	done

	# shellcheck disable=2016
	powershell.exe -NoProfile -c 'cd $HOME;' "$exe" "$cmd" "$args"
}

winget() { wsl_cmd_proxy "winget.exe" "$@"; }
scoop() { wsl_cmd_proxy "scoop" "$@"; }

zvm_vi_yank () {
	zvm_yank
	printf %s "${CUTBUFFER}" | win32yank.exe -i
	zvm_exit_visual_mode
}

zvm_vi_put_after () {
	local head= foot=
  local content=$(win32yank.exe -o)
	local offset=1
	if [[ ${content: -1} == $'\n' ]]
	then
		local pos=${CURSOR}
		for ((; $pos<$#BUFFER; pos++)) do
			if [[ ${BUFFER:$pos:1} == $'\n' ]]
			then
				pos=$pos+1
				break
			fi
		done
		if zvm_is_empty_line
		then
			head=${BUFFER:0:$pos}
			foot=${BUFFER:$pos}
		else
			head=${BUFFER:0:$pos}
			foot=${BUFFER:$pos}
			if [[ $pos == $#BUFFER ]]
			then
				content=$'\n'${content:0:-1}
				pos=$pos+1
			fi
		fi
		offset=0
		BUFFER="${head}${content}${foot}"
		CURSOR=$pos
	else
		if zvm_is_empty_line
		then
			head="${BUFFER:0:$((CURSOR-1))}"
			foot="${BUFFER:$CURSOR}"
		else
			head="${BUFFER:0:$CURSOR}"
			foot="${BUFFER:$((CURSOR+1))}"
		fi
		BUFFER="${head}${BUFFER:$CURSOR:1}${content}${foot}"
		CURSOR=$CURSOR+$#content
	fi
	zvm_highlight clear
	zvm_highlight custom $(($#head+$offset)) $(($#head+$#content+$offset))
}
