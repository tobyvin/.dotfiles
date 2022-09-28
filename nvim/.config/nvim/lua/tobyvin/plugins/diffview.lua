local utils = require("tobyvin.utils")
local M = {}

M.file_history = function()
	require("diffview").file_history(nil, vim.fn.bufname())
end

M.workspace_history = function()
	require("diffview").file_history()
end

M.selection_history = function()
	local first = vim.api.nvim_buf_get_mark(0, "<")[1]
	local last = vim.api.nvim_buf_get_mark(0, ">")[1]
	require("diffview").file_history({ first, last })
end

M.setup = function()
	local status_ok, diffview = pcall(require, "diffview")
	if not status_ok then
		vim.notify("Failed to load module 'diffview'", "error")
		return
	end

	diffview.setup()

	local nmap = utils.keymap.group("n", "<leader>g", { desc = "Git" })
	nmap("d", diffview.open, { desc = "Diffview" })
	nmap("h", M.file_history, { desc = "File History" })
	nmap("H", M.workspace_history, { desc = "Workspace History" })

	local vmap = utils.keymap.group("v", "<leader>g", { desc = "Git" })
	vmap("h", M.selection_history, { desc = "Selection History" })
end

return M
