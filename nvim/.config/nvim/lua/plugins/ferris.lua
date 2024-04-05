---@type LazyPluginSpec
local M = {
	"vxpm/ferris.nvim",
	ft = { "rust" },
	opts = {
		url_handler = vim.ui.open,
	},
}

function M:init()
	U.lsp.on_attach("rust_analyzer", function()
		vim.keymap.set("n", "gx", require("ferris.methods.open_documentation"), { desc = "open external docs" })
	end, { desc = "setup ferris keymaps" })
end

return M
