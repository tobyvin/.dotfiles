local schemastore = require("schemastore")

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
