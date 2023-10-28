vim.keymap.set("n", "gn", vim.cmd.bnext, { desc = "go to next buffer in the buffer list" })
vim.keymap.set("n", "gp", vim.cmd.bprevious, { desc = "go to previous buffer in the buffer list" })

vim.keymap.set("n", "<a-j>", "<CMD>m +1<CR>", { desc = "move line down" })
vim.keymap.set("n", "<a-k>", "<CMD>m -2<CR>", { desc = "move line up" })
vim.keymap.set("v", "<a-k>", "<CMD>m '<-2<CR>gv=gv", { desc = "move selection up" })
vim.keymap.set("v", "<a-j>", "<CMD>m '>+1<CR>gv=gv", { desc = "move selection down" })

vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], { desc = "CTRL-W" })

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "yank lines into selection register" })
vim.keymap.set({ "n", "v" }, "<leader>Y", [["+Y]], { desc = "yank lines into selection register" })
vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]], { desc = "put lines from selection register" })
vim.keymap.set({ "n", "v" }, "<leader>P", [["+P]], { desc = "put lines from selection register" })

vim.keymap.set("n", "gqq", function()
	local cursor = vim.api.nvim_win_get_cursor(0)
	vim.cmd.normal("gggqG")
	vim.api.nvim_win_set_cursor(0, cursor)
end, { desc = "format buffer" })
