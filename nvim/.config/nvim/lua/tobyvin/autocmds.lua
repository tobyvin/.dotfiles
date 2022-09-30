local M = {}

M.setup = function()
	local augroup_hl = vim.api.nvim_create_augroup("tobyvin_hl", { clear = true })

	vim.api.nvim_create_autocmd("CmdlineEnter", {
		group = augroup_hl,
		pattern = "/,?",
		callback = function()
			vim.opt.hlsearch = true
		end,
		desc = "Enable hlsearch on input",
	})

	vim.api.nvim_create_autocmd("CmdlineLeave", {
		group = augroup_hl,
		pattern = "/,?",
		callback = function()
			vim.opt.hlsearch = false
		end,
		desc = "Disable hlsearch on exit",
	})

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
		callback = function()
			vim.opt_local.tabstop = 2
		end,
		desc = "Set tabstop",
	})

	local augroup_view = vim.api.nvim_create_augroup("tobyvin_view", { clear = true })

	vim.api.nvim_create_autocmd("FileType", {
		group = augroup_view,
		pattern = { "qf", "help", "gitcommit" },
		callback = function()
			vim.opt_local.buflisted = false
		end,
		desc = "Set buffer as unlisted",
	})

	vim.api.nvim_create_autocmd("FileType", {
		group = augroup_view,
		pattern = "help",
		callback = function()
			vim.opt_local.wrap = true
			vim.opt_local.textwidth = 120
			vim.opt_local.colorcolumn = nil
			vim.cmd("wincmd L")
			vim.cmd("vertical resize " .. vim.opt.textwidth:get())
		end,
		desc = "Setup and resize help window",
	})
end

return M
