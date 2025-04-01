---@type LazySpec
local M = {
	"b0o/SchemaStore.nvim",
	version = false,
}

function M.init()
	vim.lsp.config("jsonls", {
		settings = {
			json = {
				validate = {
					enable = true,
				},
				schemas = require("schemastore").json.schemas(),
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
				schemas = require("schemastore").yaml.schemas(),
			},
		},
	})
end

return M
