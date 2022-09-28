local utils = require("tobyvin.utils")
local M = {}

M.training_wheels = function()
	vim.notify("You did the thing. Stop doing the thing. Use <C-[>", "warn", { title = "STOP DOING THAT" })
end

M.setup = function()
	vim.keymap.set("n", "<leader>q", utils.buffer.quit, { desc = "Quit" })
	vim.keymap.set("n", "<leader>c", utils.buffer.bdelete, { desc = "Close" })
	vim.keymap.set("n", "<leader>x", utils.buffer.tabclose, { desc = "Close" })
	vim.keymap.set("n", "<leader>w", "<CMD>write<CR>", { desc = "Write" })
	vim.keymap.set("i", "<C-c>", M.training_wheels, { desc = "Helper to quit using <C-c>" })
	vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Up half page and center" })
	vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Down half page and center" })
	vim.keymap.set("n", "<a-j>", "<CMD>m +1<CR>", { desc = "Move line down" })
	vim.keymap.set("n", "<a-k>", "<CMD>m -2<CR>", { desc = "Move line up" })

	vim.keymap.set("v", "<a-k>", "<CMD>m '<-2<CR>gv=gv", { desc = "Move selection up" })
	vim.keymap.set("v", "<a-j>", "<CMD>m '>+1<CR>gv=gv", { desc = "Move selection down" })

	local nmap_run = utils.keymap.group("n", "<leader>r", { desc = "Run" })

	nmap_run("c", utils.job.cmd, { desc = "Command" })
end

return M
