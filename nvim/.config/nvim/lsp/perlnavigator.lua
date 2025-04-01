---@type vim.lsp.Config
return {
	cmd = { "perlnavigator" },
	filetypes = { "perl" },
	settings = {
		perlnavigator = {
			enableWarnings = false,
		},
	},
}
