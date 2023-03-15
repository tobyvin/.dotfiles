#!/bin/sh

paste_selection_default="clipboard"
paste_selection_option="@paste_selection"

custom_paste_command_default=""
custom_paste_command_option="@custom_paste_command"

get_tmux_option() {
	option="$1"
	default_value="$2"
	option_value=$(tmux show-option -gqv "$option")
	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

paste_selection() {
	get_tmux_option "$paste_selection_option" "$paste_selection_default"
}

custom_paste_cmd() {
	get_tmux_option "$custom_paste_command_option" "$custom_paste_command_default"
}

clipboard_paste_command() {
	if [ -n "$(override_paste_cmd)" ]; then
		override_paste_cmd
	elif command -v pbpaste 1>/dev/null; then
		if command -v reattach-to-user-namespace 1>/dev/null; then
			echo "reattach-to-user-namespace pbpaste"
		else
			echo "pbpaste"
		fi
	elif command -v win32yank.exe 1>/dev/null; then
		echo "win32yank.exe -o"
	elif [ -n "$DISPLAY" ] && command -v xsel 1>/dev/null; then
		echo "xsel -o --$(paste_selection)"
	elif [ -n "$DISPLAY" ] && command -v xclip 1>/dev/null; then
		echo "xclip -o -selection $(paste_selection)"
	elif command -v getclip 1>/dev/null; then
		echo "getclip"
	elif [ -n "$(custom_paste_cmd)" ]; then
		custom_paste_cmd
	fi
}

main() {
	paste_command="$(clipboard_paste_command)"
	if [ -n "$paste_command" ]; then
		tmux set-hook -g client-focus-in "run '$paste_command | tmux load-buffer -b clipboard -'"
	fi
}

main
