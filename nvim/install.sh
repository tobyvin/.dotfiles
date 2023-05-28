#!/usr/bin/sh

SCRIPT="$0"

say() {
	printf "%s: %s\n" "$SCRIPT" "$@"
}

# Update plugins
say "Updating plugins to lock-file"
nvim --headless -c 'Lazy! restore' -c qa
nvim --headless -c 'Lazy! clean' -c qa

# Update LSP servers
say "Updating LSP servers"
nvim --headless -c 'autocmd User MasonUpdateAllComplete quitall' -c 'MasonUpdateAll'
