---@type LazyPluginSpec
local M = {
	"folke/todo-comments.nvim",
	cmd = { "TodoTrouble", "TodoTelescope" },
	event = "BufReadPost",
	config = true,
}

function M.init()
	vim.keymap.set("n", "]t", function()
		require("todo-comments").jump_next()
	end, { desc = "next todo" })

	vim.keymap.set("n", "[t", function()
		require("todo-comments").jump_prev()
	end, { desc = "previous todo" })
end

return M
