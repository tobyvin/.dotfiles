local utils = require("tobyvin.utils")
local M = {}

M.training_wheels = function()
	vim.notify("You did the thing. Stop doing the thing. Use <C-[>", vim.log.levels.WARN, { title = "STOP DOING THAT" })
end

M.setup = function()
	for i = 1, 99, 1 do
		local lhs = string.format("%sgb", i)
		local desc = string.format("buffer %s", i)
		local rhs = string.format("<cmd>%sb<cr>", i)
		vim.keymap.set("n", lhs, rhs, { desc = desc })
	end

	vim.keymap.set("n", "gn", "<cmd>bnext<cr>", { desc = "bnext" })
	vim.keymap.set("n", "gp", "<cmd>bprev<cr>", { desc = "bprev" })
	vim.keymap.set("n", "gb", utils.buffer.bselect, { desc = "bselect" })
	vim.keymap.set("n", "<leader>q", "<cmd>qall<cr>", { desc = "quit" })
	vim.keymap.set("n", "<leader>c", utils.buffer.bdelete, { desc = "bdelete" })
	vim.keymap.set("n", "<leader>x", "<cmd>close<cr>", { desc = "close" })
	vim.keymap.set("n", "<leader>z", "<cmd>tabclose<cr>", { desc = "tabclose" })
	vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "write" })
	vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Up half page and center" })
	vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Down half page and center" })
	vim.keymap.set("n", "<a-j>", "<CMD>m +1<CR>", { desc = "Move line down" })
	vim.keymap.set("n", "<a-k>", "<CMD>m -2<CR>", { desc = "Move line up" })
	vim.keymap.set("v", "<a-k>", "<CMD>m '<-2<CR>gv=gv", { desc = "Move selection up" })
	vim.keymap.set("v", "<a-j>", "<CMD>m '>+1<CR>gv=gv", { desc = "Move selection down" })
	vim.keymap.set("i", "<C-c>", M.training_wheels, { desc = "Helper to quit using <C-c>" })
end

return M
