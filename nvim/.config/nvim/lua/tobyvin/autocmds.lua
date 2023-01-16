local augroup = vim.api.nvim_create_augroup("tobyvin", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank()
	end,
	desc = "Highlight yank",
})

vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	callback = function(args)
		local file = vim.loop.fs_realpath(args.match) or args.match
		local parent = vim.fn.fnamemodify(file, ":h")
		local stat = vim.loop.fs_stat(parent)

		if stat then
			if stat.type ~= "directory" then
				vim.notify(
					string.format("cannot create directory ‘%s’: Not a directory", parent),
					vim.log.levels.ERROR
				)
			end
			return
		end

		local prompt = string.format("'%s' does not exist. Create it?", parent)
		if vim.fn.confirm(prompt, "&Yes\n&No") == 1 then
			vim.fn.mkdir(vim.fn.fnamemodify(parent, ":p"), "p")
		end
	end,
	desc = "Check for missing directory on write",
})

vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	pattern = "*",
	callback = function()
		local cursor = vim.api.nvim_win_get_cursor(0)
		vim.cmd("%s/\\s\\+$//e")
		vim.api.nvim_win_set_cursor(0, cursor)
	end,
	desc = "Trim whitespace on write",
})

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "c", "sh", "zsh", "xml", "html", "xhtml", "css", "scss", "javascript", "lua", "dart", "markdown" },
	callback = function(args)
		vim.bo[args.buf].tabstop = 2
	end,
	desc = "Set tabstop",
})

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "qf", "help", "gitcommit", "gitrebase", "Neogit*" },
	callback = function(args)
		vim.bo[args.buf].buflisted = false
	end,
	desc = "Set buffer as unlisted",
})

-- FIX: fix `help` command causes `Vim:E565: Not allowed to change text or change window`
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "vim", "lua" },
	callback = function(args)
		require("tobyvin.utils.documentation").register(function()
			local word = vim.fn.expand("<cword>")
			if word then
				vim.cmd.help(word)
			end
		end, { desc = "help", priority = 5, buffer = args.buf })
	end,
	desc = "Register help documentation provider",
})

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = "help",
	callback = function()
		vim.opt_local.colorcolumn = nil
		vim.cmd.wincmd("L")
	end,
	desc = "Vertical help window",
})
