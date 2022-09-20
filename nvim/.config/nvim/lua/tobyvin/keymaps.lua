local utils = require("tobyvin.utils")
local M = {}

M.write = function()
	vim.cmd("write")
end

M.training_wheels = function()
	vim.notify("You did the thing. Stop doing the thing. Use <C-[>", "warn", { title = "STOP DOING THAT" })
end

M.setup = function()
	vim.keymap.set("i", "<C-c>", M.training_wheels, { desc = "Helper to quit using <C-c>" })
	vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Up half page and center" })
	vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Down half page and center" })
	vim.keymap.set("n", "<leader>q", utils.quit, { desc = "Quit" })
	vim.keymap.set("n", "<leader>c", utils.bdelete, { desc = "Close" })
	vim.keymap.set("n", "<leader>x", utils.tabclose, { desc = "Close" })
	vim.keymap.set("n", "<leader>h", utils.hover, { desc = "Hover" })
	vim.keymap.set("n", "<leader>H", utils.docs, { desc = "Docs" })
	vim.keymap.set("n", "<leader>w", M.write, { desc = "Write" })

	vim.keymap.set("v", "<a-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
	vim.keymap.set("v", "<a-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })

	local nmap_run = utils.create_map_group("n", "<leader>r", { desc = "Run" })

	nmap_run("c", utils.run_cmd_with_args, { desc = "Command" })
end

return M
