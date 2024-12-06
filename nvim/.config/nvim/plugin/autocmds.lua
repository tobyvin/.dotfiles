vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("user", { clear = true }),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank()
	end,
	desc = "vim.highlight.on_yank()",
})
