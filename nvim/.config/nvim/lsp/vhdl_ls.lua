---@type vim.lsp.Config
return {
	cmd = { "vhdl_ls" },
	filetypes = { "vhd", "vhdl" },
	root_markers = {
		"vhdl_ls.toml",
		".vhdl_ls.toml",
	},
}
