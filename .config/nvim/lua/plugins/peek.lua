---@type LazyPluginSpec
local M = {
	"toppair/peek.nvim",
	cond = vim.fn.executable("deno") == 1,
	ft = { "markdown" },
	build = "deno task --quiet build:fast",
	opts = {
		auto_load = false,
		close_on_bdelete = true,
		syntax = true,
		update_on_change = true,
		app = "webview",
		filetype = { "markdown" },
	},
}

function M:config(opts)
	require("peek").setup(opts)

	vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {
		desc = "open markdown preview",
	})
	vim.api.nvim_create_user_command("PeekClose", require("peek").close, {
		desc = "close markdown preview",
	})
end

return M
