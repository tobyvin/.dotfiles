#!/bin/sh

if command -v mbsync >/dev/null; then
	systemctl --user enable --now mbsync.service
else
	cat <<-EOF
		command not found: mbsync

		install 'isync' package:
		  paru -S isync
	EOF
fi

if command -v goimapnotify >/dev/null; then
	systemctl --user enable --now goimapnotify@gmail.service
	systemctl --user enable --now goimapnotify@porkbun.service
else
	cat <<-EOF
		command not found: goimapnotify

		install 'goimapnotify' package:
		  paru -S goimapnotify
	EOF
fi

systemctl --user enable --now maildir-notify@gmail.service
systemctl --user enable --now maildir-notify@porkbun.service
