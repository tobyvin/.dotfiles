local augroup = vim.api.nvim_create_augroup("tobyvin", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	pattern = "*",
	callback = vim.highlight.on_yank,
	desc = "vim.highlight.on_yank()",
})

vim.api.nvim_create_autocmd("VimEnter", {
	group = augroup,
	callback = U.buf.on_enter,
	desc = "U.buf.on_enter()",
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = augroup,
	callback = U.session.on_exit,
	desc = "U.session.on_exit()",
})

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
