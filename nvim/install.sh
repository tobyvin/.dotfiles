#!/usr/bin/sh

echo "Installing nvim"

# Update plugins
nvim --headless "+Lazy! sync" +qa

# Update LSP servers
nvim --headless -c 'autocmd User MasonUpdateAllComplete quitall' -c 'MasonUpdateAll'
