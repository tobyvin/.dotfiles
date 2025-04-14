vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("user", { clear = true }),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank()
	end,
	desc = "vim.highlight.on_yank()",
})

-- Override ftplugins that override formatoptions
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("user.options", { clear = true }),
	callback = function()
		vim.opt_local.formatoptions:remove("o")
	end,
})
