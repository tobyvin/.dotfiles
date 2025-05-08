vim.opt_local.scrolloff = 0
vim.keymap.set("n", "<ESC>", function()
	vim.api.nvim_buf_delete(0, {})
end, { desc = "close", buffer = 0 })
