local success, lazydev = pcall(require, "lazydev")
if not success then
	return
end

lazydev.setup({
	library = {
		{ path = "luvit-meta", words = { "vim%.uv" } },
		{ path = "tex-luatex", words = { "tex" } },
		{ path = "tex-lualatex", words = { "tex" } },
		{ path = "tex-luametatex", words = { "tex" } },
		{ path = "tex-lualibs", words = { "tex" } },
		{ path = "mpv-types-lua/types", mods = { "mp", "mp.msg", "mp.options", "mp.assdraw", "mp.utils" } },
		{ path = "cc-tweaked-documentation", words = { "cc" } },
	},
	integrations = {
		lspconfig = false,
		cmp = false,
	},
})
