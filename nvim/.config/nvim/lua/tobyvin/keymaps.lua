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
	vim.keymap.set("n", "gk", utils.documentation.open, { desc = "documentation" })
	vim.keymap.set("n", "K", function()
		if utils.hover.open() then
			-- Fix for diagnostics immediately overriding hover window
			vim.api.nvim_command("set eventignore=CursorHold")
			vim.api.nvim_command('autocmd CursorMoved <buffer> ++once set eventignore=""')
			return "<Ignore>"
		end
		return "K"
	end, { expr = true, desc = "hover" })

	vim.keymap.set("n", "<leader>q", "<cmd>qall<cr>", { desc = "quit" })
	vim.keymap.set("n", "<leader>c", utils.buffer.bdelete, { desc = "bdelete" })
	vim.keymap.set("n", "<leader>x", "<cmd>close<cr>", { desc = "close" })
	vim.keymap.set("n", "<leader>z", "<cmd>tabclose<cr>", { desc = "tabclose" })
	vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "write" })

	vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "up half page and center" })
	vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "down half page and center" })
	vim.keymap.set("n", "<a-j>", "<CMD>m +1<CR>", { desc = "move line down" })
	vim.keymap.set("n", "<a-k>", "<CMD>m -2<CR>", { desc = "move line up" })
	vim.keymap.set("v", "<a-k>", "<CMD>m '<-2<CR>gv=gv", { desc = "move selection up" })
	vim.keymap.set("v", "<a-j>", "<CMD>m '>+1<CR>gv=gv", { desc = "move selection down" })
	vim.keymap.set("i", "<C-c>", M.training_wheels, { desc = "helper to quit using <C-c>" })
end

return M
