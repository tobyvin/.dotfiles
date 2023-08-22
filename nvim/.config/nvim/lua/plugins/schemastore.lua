---@type LazyPluginSpec
local M = {
	"b0o/SchemaStore.nvim",
}

function M.init()
	require("tobyvin.lsp.configs").jsonls.on_new_config = function(new_config)
		new_config.settings.json.schemas = new_config.settings.json.schemas or {}
		vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
	end
end

return M
