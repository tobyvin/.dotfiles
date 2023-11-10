---@type LazyPluginSpec
local M = {
	"toppair/peek.nvim",
	build = vim.fn.executable("deno") == 1 and "deno task --quiet build:fast" or nil,
	opts = {
		auto_load = false,
		close_on_bdelete = true,
		syntax = true,
		update_on_change = true,
		app = "webview",
		filetype = { "markdown" },
	},
}

function M:init()
	if not M.build or vim.env.SSH_CLIENT or vim.env.SSH_TTY then
		return
	end

	vim.api.nvim_create_user_command("PeekOpen", U.lazy_require("peek").open, {
		desc = "open peek.nvim markdown preview",
	})
	vim.api.nvim_create_user_command("PeekClose", U.lazy_require("peek").close, {
		desc = "close peek.nvim markdown preview",
	})
end

return M
