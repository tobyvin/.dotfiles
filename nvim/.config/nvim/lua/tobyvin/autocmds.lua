local M = {}

M.setup = function()
	local augroup_hl = vim.api.nvim_create_augroup("tobyvin_hl", { clear = true })

	vim.api.nvim_create_autocmd("TextYankPost", {
		group = augroup_hl,
		pattern = "*",
		callback = function()
			vim.highlight.on_yank()
		end,
		desc = "Highlight yank",
	})

	local augroup_fmt = vim.api.nvim_create_augroup("tobyvin_fmt", { clear = true })

	vim.api.nvim_create_autocmd("BufWritePre", {
		group = augroup_fmt,
		pattern = "*",
		callback = function()
			local cursor = vim.api.nvim_win_get_cursor(0)
			vim.cmd("%s/\\s\\+$//e")
			vim.api.nvim_win_set_cursor(0, cursor)
		end,
		desc = "Trim whitespace on write",
	})

	vim.api.nvim_create_autocmd("FileType", {
		group = augroup_fmt,
		pattern = { "sh", "zsh", "xml", "html", "xhtml", "css", "scss", "javascript", "lua", "dart", "markdown" },
		callback = function(args)
			vim.bo[args.buf].tabstop = 2
		end,
		desc = "Set tabstop",
	})

	local augroup_view = vim.api.nvim_create_augroup("tobyvin_view", { clear = true })

	vim.api.nvim_create_autocmd("FileType", {
		group = augroup_view,
		pattern = { "qf", "help", "gitcommit", "gitrebase", "Neogit*" },
		callback = function(args)
			vim.bo[args.buf].buflisted = false
		end,
		desc = "Set buffer as unlisted",
	})

	vim.api.nvim_create_autocmd("FileType", {
		group = augroup_view,
		pattern = "help",
		callback = function(args)
			vim.wo.wrap = true
			vim.bo[args.buf].textwidth = 120
			vim.wo.colorcolumn = nil
			vim.cmd("wincmd L")
			vim.api.nvim_win_set_width(0, vim.o.textwidth)
		end,
		desc = "Setup and resize help window",
	})

	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("tobyvin_reload", { clear = true }),
		pattern = "lua",
		callback = function(args)
			local utils = require("tobyvin.utils")
			if utils.fs.module_from_path(args.file) then
				vim.keymap.set("n", "<leader>R", utils.fs.reload, { desc = "reload lua module" })
			end
		end,
		desc = "Setup lua module reloader",
	})
end

return M
