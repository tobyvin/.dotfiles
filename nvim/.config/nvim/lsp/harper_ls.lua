---@type vim.lsp.Config
return {
	cmd = { "harper-ls", "--stdio" },
	filetypes = {
		"markdown",
		"text",
		"tex",
		"typst",
	},
	root_markers = { ".harper-dictionary.txt", ".git" },
	settings = {
		["harper-ls"] = {
			markdown = {
				IgnoreLinkTitle = true,
			},
		},
	},
	-- on_attach = function(client, _)
	-- 	local ns = vim.lsp.diagnostic.get_namespace(client.id)
	-- 	vim.diagnostic.config({ virtual_lines = true }, ns)
	-- end,
}
