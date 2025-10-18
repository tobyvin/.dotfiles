-- TODO: eventually replace with native nvim_echo progress messages
-- Ref: https://github.com/neovim/neovim/issues/32537
require("fidget").setup({
	notification = {
		window = {
			winblend = 0,
		},
	},
})
