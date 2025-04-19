---@type LazySpec
local M = {
	"Bilal2453/luvit-meta",
	"LuaCATS/tex-luatex",
	"LuaCATS/tex-lualatex",
	"LuaCATS/tex-luametatex",
	"LuaCATS/tex-lualibs",
	{
		"https://gitlab.com/carsakiller/cc-tweaked-documentation",
		name = "cc-tweaked",
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		cmd = "LazyDev",
		opts = {
			library = {
				"lazy.nvim",
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
				{ path = "tex-luatex", words = { "tex" } },
				{ path = "tex-lualatex", words = { "tex" } },
				{ path = "tex-luametatex", words = { "tex" } },
				{ path = "tex-lualibs", words = { "tex" } },
				{ path = "cc-tweaked", words = { "cc" } },
			},
			integrations = {
				lspconfig = false,
				cmp = false,
			},
		},
	},
}

return M
