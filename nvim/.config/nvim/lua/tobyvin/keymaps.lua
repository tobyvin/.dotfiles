local utils = require("tobyvin.utils")

local hover = function()
	if utils.hover.open() then
		-- Fix for diagnostics immediately overriding hover window
		vim.api.nvim_command("set eventignore=CursorHold")
		vim.api.nvim_command('autocmd CursorMoved <buffer> ++once set eventignore=""')
		return "<Ignore>"
	end
	return "K"
end

vim.keymap.set("n", "gn", "<cmd>bnext<cr>", { desc = "bnext" })
vim.keymap.set("n", "gp", "<cmd>bprev<cr>", { desc = "bprev" })
vim.keymap.set("n", "gk", utils.documentation.open, { desc = "documentation" })
vim.keymap.set("n", "K", hover, { expr = true, desc = "hover" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "up half page and center" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "down half page and center" })
vim.keymap.set("n", "<a-j>", "<CMD>m +1<CR>", { desc = "move line down" })
vim.keymap.set("n", "<a-k>", "<CMD>m -2<CR>", { desc = "move line up" })
vim.keymap.set("v", "<a-k>", "<CMD>m '<-2<CR>gv=gv", { desc = "move selection up" })
vim.keymap.set("v", "<a-j>", "<CMD>m '>+1<CR>gv=gv", { desc = "move selection down" })
