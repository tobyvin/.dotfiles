local augroup = vim.api.nvim_create_augroup("tobyvin", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank()
	end,
	desc = "Highlight yank",
})

vim.api.nvim_create_autocmd("VimEnter", {
	group = augroup,
	callback = U.buf.on_enter,
	desc = "setup initial buffer",
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = augroup,
	callback = U.session.on_exit,
	desc = "write session on vim exit",
})

vim.api.nvim_create_autocmd({ "WinEnter", "TermOpen" }, {
	group = augroup,
	pattern = string.format("term://*:%s", vim.env.SHELL),
	command = "startinsert",
	desc = "start terminal mode",
})

vim.api.nvim_create_autocmd("TermOpen", {
	group = augroup,
	pattern = "term://*",
	command = "normal G",
	desc = "move to bottom of terminal",
})
