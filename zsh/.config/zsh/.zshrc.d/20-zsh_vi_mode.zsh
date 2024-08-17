#!/usr/bin/zsh

zvm_config() {
	ZVM_VI_HIGHLIGHT_FOREGROUND=black
	ZVM_VI_HIGHLIGHT_BACKGROUND=white
}

function zvm_after_init() {
	zvm_set_cb() {
		printf "\e]52;c;%s\a" "$(printf '%b' $1 | openssl base64 -A)"
	}

	functions -c zvm_vi_yank _zvm_vi_yank
	unfunction zvm_vi_yank
	zvm_vi_yank() {
		_zvm_vi_yank
		zvm_set_cb "${CUTBUFFER}"
	}

	functions -c zvm_vi_delete _zvm_vi_delete
	unfunction zvm_vi_delete
	zvm_vi_delete() {
		_zvm_vi_delete
		zvm_set_cb "${CUTBUFFER}"
	}

	functions -c zvm_vi_change _zvm_vi_change
	unfunction zvm_vi_change
	zvm_vi_change() {
		_zvm_vi_change
		zvm_set_cb "${CUTBUFFER}"
	}

	functions -c zvm_vi_change_eol _zvm_vi_change_eol
	unfunction zvm_vi_change_eol
	zvm_vi_change_eol() {
		_zvm_vi_change_eol
		zvm_set_cb "${CUTBUFFER}"
	}
}
