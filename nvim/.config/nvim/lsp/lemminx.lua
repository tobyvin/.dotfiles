---@type vim.lsp.Config
return {
	cmd = { "lemminx" },
	filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
	root_markers = { ".git" },
	settings = {
		xml = {
			catalogs = { "/etc/xml/catalog" },
		},
	},
}
