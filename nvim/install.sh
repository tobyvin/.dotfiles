#!/usr/bin/sh

SCRIPT="$0"

say() {
	printf "%s: %s\n" "$SCRIPT" "$@"
}

# Update plugins
say "Updating plugins"
nvim --headless -c 'Lazy! sync' -c qa

# Update LSP servers
say "Updating LSP servers"
nvim --headless -c 'autocmd User MasonUpdateAllComplete quitall' -c 'MasonUpdateAll'
