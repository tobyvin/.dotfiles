#!/usr/bin/zsh

zvm_config() {
	ZVM_VI_HIGHLIGHT_FOREGROUND=black
	ZVM_VI_HIGHLIGHT_BACKGROUND=white
}

function zvm_after_init() {
	functions -c zvm_vi_yank _zvm_vi_yank
	unfunction zvm_vi_yank
	zvm_vi_yank() {
		_zvm_vi_yank
		echo -en "${CUTBUFFER}" | wl-copy
	}

	functions -c zvm_vi_delete _zvm_vi_delete
	unfunction zvm_vi_delete
	zvm_vi_delete() {
		_zvm_vi_delete
		echo -en "${CUTBUFFER}" | wl-copy
	}

	functions -c zvm_vi_change _zvm_vi_change
	unfunction zvm_vi_change
	zvm_vi_change() {
		_zvm_vi_change
		echo -en "${CUTBUFFER}" | wl-copy
	}

	functions -c zvm_vi_change_eol _zvm_vi_change_eol
	unfunction zvm_vi_change_eol
	zvm_vi_change_eol() {
		_zvm_vi_change_eol
		echo -en "${CUTBUFFER}" | wl-copy
	}

	functions -c zvm_vi_put_after _zvm_vi_put_after
	unfunction zvm_vi_put_after
	zvm_vi_put_after() {
		CUTBUFFER=$(wl-paste)
		_zvm_vi_put_after
		zvm_highlight clear # fix weird highlighting
	}

	functions -c zvm_vi_put_before _zvm_vi_put_before
	unfunction zvm_vi_put_before
	zvm_vi_put_before() {
		CUTBUFFER=$(wl-paste)
		_zvm_vi_put_before
		zvm_highlight clear # fix weird highlighting
	}

	functions -c zvm_vi_replace_selection _zvm_vi_replace_selection
	unfunction zvm_vi_replace_selection
	zvm_vi_replace_selection() {
		CUTBUFFER=$(wl-paste)
		_zvm_vi_replace_selection
		zvm_highlight clear # fix weird highlighting
		echo -en "${CUTBUFFER}" | wl_copy
	}
}
