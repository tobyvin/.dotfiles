local Path = require("plenary").path

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("tobyvin_hl", { clear = true }),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank()
	end,
	desc = "Highlight yank",
})

vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("tobyvin_mkdir", { clear = true }),
	callback = function(args)
		local parent = Path:new(args.file):parent()
		local prompt = string.format("%s does not exist. Create it?", parent:make_relative())
		if not parent:is_dir() and vim.fn.confirm(prompt, "&Yes\n&No") == 1 then
			parent:mkdir()
		end
	end,
	desc = "Check for missing directory on write",
})

vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("tobyvin_whitespace", { clear = true }),
	pattern = "*",
	callback = function()
		local cursor = vim.api.nvim_win_get_cursor(0)
		vim.cmd("%s/\\s\\+$//e")
		vim.api.nvim_win_set_cursor(0, cursor)
	end,
	desc = "Trim whitespace on write",
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("tobyvin_tabstop", { clear = true }),
	pattern = { "sh", "zsh", "xml", "html", "xhtml", "css", "scss", "javascript", "lua", "dart", "markdown" },
	callback = function(args)
		vim.bo[args.buf].tabstop = 2
	end,
	desc = "Set tabstop",
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("tobyvin_unlisted", { clear = true }),
	pattern = { "qf", "help", "gitcommit", "gitrebase", "Neogit*" },
	callback = function(args)
		vim.bo[args.buf].buflisted = false
	end,
	desc = "Set buffer as unlisted",
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("tobyvin_help", { clear = true }),
	pattern = "help",
	callback = function()
		vim.wo.colorcolumn = nil
		vim.cmd("wincmd L")
	end,
	desc = "Vertical help window",
})
