---@type LazyPluginSpec
local M = {
	"b0o/SchemaStore.nvim",
}

function M.init()
	local lsp_settings = {
		jsonls = {
			settings = {
				json = {
					validate = {
						enable = true,
					},
					schemas = require("schemastore").json.schemas(),
				},
			},
		},
		yamlls = {
			settings = {
				yaml = {
					schemaStore = {
						enable = false,
						url = "",
					},
					schemas = require("schemastore").yaml.schemas(),
				},
			},
		},
	}

	for name, override in vim.iter(lsp_settings) do
		local config = require("tobyvin.lsp.configs")[name]
		if config then
			require("tobyvin.lsp.configs")[name] = vim.tbl_extend("force", config, override)
		end
	end
end

return M
