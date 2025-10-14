local success, schemastore = pcall(require, "schemastore")
if not success then
	return
end

vim.lsp.config("jsonls", {
	settings = {
		json = {
			validate = {
				enable = true,
			},
			schemas = schemastore.json.schemas(),
		},
	},
})

vim.lsp.config("yamlls", {
	settings = {
		yaml = {
			schemaStore = {
				enable = false,
				url = "",
			},
			schemas = schemastore.yaml.schemas(),
		},
	},
})
