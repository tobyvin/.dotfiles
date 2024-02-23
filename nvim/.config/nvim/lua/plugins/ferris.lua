---@type LazyPluginSpec
local M = {
	"vxpm/ferris.nvim",
	ft = { "rust" },
	opts = {
		url_handler = vim.ui.open,
	},
}

function M:init()
	U.on_attach(function()
		vim.keymap.set("n", "gx", require("ferris.methods.open_documentation"), { desc = "open external docs" })
	end, { name = "rust_analyzer" })
end

return M
