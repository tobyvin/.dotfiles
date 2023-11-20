---@type LazyPluginSpec
local M = {
	"vxpm/ferris.nvim",
	opts = {
		url_handler = vim.ui.open,
	},
}

function M:init()
	U.on_attach(function()
		require("ferris")
	end, { name = "rust_analyzer" })
end

return M
