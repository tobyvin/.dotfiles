local status_ok, diffview = pcall(require, "diffview")
if not status_ok then
	vim.notify("Failed to load module 'diffview'", vim.log.levels.ERROR)
	return
end

local file_history = function()
	require("diffview").file_history(nil, vim.fn.bufname())
end

local workspace_history = function()
	require("diffview").file_history()
end

local selection_history = function()
	local first = vim.api.nvim_buf_get_mark(0, "<")[1]
	local last = vim.api.nvim_buf_get_mark(0, ">")[1]
	require("diffview").file_history({ first, last })
end

diffview.setup()

vim.keymap.set("n", "<leader>gd", diffview.open, { desc = "diffview" })
vim.keymap.set("n", "<leader>gh", file_history, { desc = "file history" })
vim.keymap.set("n", "<leader>gH", workspace_history, { desc = "workspace history" })
vim.keymap.set("v", "<leader>gh", selection_history, { desc = "selection history" })
