---@type LazySpec
local M = {
	"Bilal2453/luvit-meta",
	"LuaCATS/tex-luatex",
	"LuaCATS/tex-lualatex",
	"LuaCATS/tex-luametatex",
	"LuaCATS/tex-lualibs",
	"disco0/mpv-types-lua",
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
				{ path = "luvit-meta", words = { "vim%.uv" } },
				{ path = "tex-luatex", words = { "tex" } },
				{ path = "tex-lualatex", words = { "tex" } },
				{ path = "tex-luametatex", words = { "tex" } },
				{ path = "tex-lualibs", words = { "tex" } },
				{ path = "mpv-types-lua/types", mods = { "mp", "mp.msg", "mp.options", "mp.assdraw", "mp.utils" } },
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
