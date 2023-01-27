local augroup = vim.api.nvim_create_augroup("tobyvin", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ macro = true })
	end,
	desc = "Highlight yank",
})

vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	callback = function(args)
		local file = vim.loop.fs_realpath(args.match) or args.match
		local parent = vim.fn.fnamemodify(file, ":h")
		local stat = vim.loop.fs_stat(parent)

		if not stat then
			local prompt = string.format("'%s' does not exist. Create it?", parent)
			if vim.fn.confirm(prompt, "&Yes\n&No") == 1 then
				vim.fn.mkdir(vim.fn.fnamemodify(parent, ":p"), "p")
			end
		elseif stat.type ~= "directory" then
			local msg = string.format("cannot create directory ‘%s’: Not a directory", parent)
			vim.notify(msg, vim.log.levels.ERROR)
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
	pattern = {
		"c",
		"sh",
		"zsh",
		"xml",
		"html",
		"xhtml",
		"css",
		"scss",
		"javascript",
		"lua",
		"markdown",
	},
	callback = function(args)
		vim.bo[args.buf].tabstop = 2
	end,
	desc = "Set tabstop",
})

vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = {
		"qf",
		"help",
		"gitcommit",
		"gitrebase",
		"Neogit*",
	},
	callback = function(args)
		vim.bo[args.buf].buflisted = false
	end,
	desc = "Set buffer as unlisted",
})
