local augroup = vim.api.nvim_create_augroup("term", { clear = true })

vim.api.nvim_create_autocmd({ "WinEnter", "TermOpen" }, {
	group = augroup,
	pattern = string.format("term://*:%s", vim.env.SHELL),
	command = "startinsert",
})

vim.api.nvim_create_autocmd("TermOpen", {
	group = augroup,
	pattern = "term://*",
	command = "normal G",
})
