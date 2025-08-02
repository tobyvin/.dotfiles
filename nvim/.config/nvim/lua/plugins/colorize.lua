---@type LazySpec
local M = {
	"NvChad/nvim-colorizer.lua",
	ft = {
		"css",
		"scss",
		"sass",
		"javascript",
		"html",
		"htmldjango",
	},
	opts = {
		filetypes = {
			"css",
			"scss",
			"sass",
			"javascript",
			"html",
			"htmldjango",
		},
		user_default_options = {
			mode = "virtualtext",
			xterm = true,
		},
		virtualtext_inline = true,
	},
}

return M
