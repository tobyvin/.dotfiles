local augroup = vim.api.nvim_create_augroup("user", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank()
	end,
	desc = "vim.highlight.on_yank()",
})

-- Override ftplugins that override formatoptions
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	callback = function()
		vim.opt_local.formatoptions:remove("o")
	end,
	desc = "Override ftplugins that override formatoptions",
})

vim.api.nvim_create_autocmd("BufWritePost", {
	group = augroup,
	pattern = ".nvim.lua",
	callback = function()
		vim.secure.trust({
			action = "allow",
			bufnr = vim.api.nvim_get_current_buf(),
		})
	end,
	desc = "Trust exrc files after write",
})
