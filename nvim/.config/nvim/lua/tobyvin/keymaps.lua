vim.keymap.set("n", "gn", vim.cmd.bnext, { desc = "go to next buffer in the buffer list" })
vim.keymap.set("n", "gp", vim.cmd.bprevious, { desc = "go to previous buffer in the buffer list" })

vim.keymap.set("n", "<a-j>", "<CMD>m +1<CR>", { desc = "move line down" })
vim.keymap.set("n", "<a-k>", "<CMD>m -2<CR>", { desc = "move line up" })
vim.keymap.set("v", "<a-k>", "<CMD>m '<-2<CR>gv=gv", { desc = "move selection up" })
vim.keymap.set("v", "<a-j>", "<CMD>m '>+1<CR>gv=gv", { desc = "move selection down" })

vim.keymap.set("n", "<leader>sr", require("tobyvin.utils.session").read, { desc = "read session" })
vim.keymap.set("n", "<leader>sw", require("tobyvin.utils.session").write, { desc = "write session" })

vim.keymap.set("n", "gqq", function()
	local cursor = vim.api.nvim_win_get_cursor(0)
	vim.cmd.normal("gggqG")
	vim.api.nvim_win_set_cursor(0, cursor)
end, { desc = "format buffer" })
