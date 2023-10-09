---@diagnostic disable: param-type-mismatch
---@type LazyPluginSpec
local M = {
	"stevearc/oil.nvim",
	version = "*",
	cmd = { "Oil" },
	event = { "BufNew", "ColorScheme", "SessionLoadPost" },
	opts = {
		default_file_explorer = true,
		skip_confirm_for_simple_edits = true,
		view_options = {
			show_hidden = true,
		},
	},
}

function M:init()
	vim.keymap.set("n", "-", function()
		require("oil").open()
	end, { desc = "Open parent directory" })

	if vim.fn.argc() == 1 then
		local stat = vim.loop.fs_stat(vim.fn.argv(0))
		local adapter = string.match(vim.fn.argv(0), "^([%l-]*)://")
		if (stat and stat.type == "directory") or adapter == "oil-ssh" then
			require("lazy").load({ plugins = { "oil.nvim" } })
		end
	end
end

return M
