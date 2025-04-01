---@type vim.lsp.Config
return {
	cmd = { "typos-lsp" },
	filetypes = {
		"eml",
		"gitcommit",
		"mail",
		"markdown",
		"tex",
	},
	root_markers = { "typos.toml", "_typos.toml", ".typos.toml" },
	init_options = {
		config = vim.fs.joinpath(vim.env.XDG_CONFIG_HOME, "typos.toml"),
	},
}
