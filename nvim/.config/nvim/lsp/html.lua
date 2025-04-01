---@type vim.lsp.Config
return {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = {
		"html",
		"templ",
		"htmldjango",
	},
	root_markers = { "package.json", ".git" },
	init_options = {
		provideFormatter = true,
		embeddedLanguages = { css = true, javascript = true },
		configurationSection = { "html", "css", "javascript" },
	},
	handlers = {
		-- TODO: Find out why html ls is missing diagnostic handler without this.
		[vim.lsp.protocol.Methods.textDocument_diagnostic] = vim.lsp.diagnostic.on_diagnostic,
	},
	settings = {
		html = {
			provideFormatter = false,
		},
	},
}
