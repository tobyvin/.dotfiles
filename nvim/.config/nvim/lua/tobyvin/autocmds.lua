local M = {}

M.setup = function()
	local augroup_user = vim.api.nvim_create_augroup("Default", { clear = true })

	vim.api.nvim_create_autocmd("User", {
		group = augroup_user,
		pattern = "bdelete",
		callback = function(opts)
			local windows = vim.tbl_filter(function(win)
				return vim.api.nvim_win_get_buf(win) == opts.bufnr
			end, vim.api.nvim_list_wins())

			local buffers = vim.tbl_filter(function(buf)
				return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
			end, vim.api.nvim_list_bufs())

			if buffers ~= nil and #buffers > 1 then
				local next_buffer = vim.fn.winbufnr(vim.fn.winnr("#"))

				if not next_buffer then
					for i, v in ipairs(buffers) do
						if v == opts.bufnr then
							next_buffer = buffers[i % #buffers + 1]
							break
						end
					end
				end

				for _, win in ipairs(windows) do
					vim.api.nvim_win_set_buf(win, next_buffer)
				end
			end
		end,
		desc = "Sets the window to the alternate buffer for bdelete",
	})

	local augroup_default = vim.api.nvim_create_augroup("Default", { clear = true })

	vim.api.nvim_create_autocmd("TextYankPost", {
		group = augroup_default,
		pattern = "*",
		callback = function()
			vim.highlight.on_yank()
		end,
		desc = "Highlight yank",
	})

	vim.api.nvim_create_autocmd("BufWritePre", {
		group = augroup_default,
		pattern = "*",
		callback = function()
			local cursor = vim.api.nvim_win_get_cursor(0)
			vim.cmd("%s/\\s\\+$//e")
			vim.api.nvim_win_set_cursor(0, cursor)
		end,
		desc = "Trim whitespace on write",
	})

	vim.api.nvim_create_autocmd("FileType", {
		group = augroup_default,
		pattern = "help",
		callback = function()
			vim.opt_local.wrap = true
			vim.opt_local.textwidth = 120
			vim.opt_local.colorcolumn = nil
			vim.cmd("wincmd L")
			vim.cmd("vertical resize " .. vim.opt.textwidth:get())
		end,
		desc = "Resize help window",
	})

	vim.api.nvim_create_autocmd("FileType", {
		group = augroup_default,
		pattern = "qf",
		callback = function()
			vim.opt_local.buflisted = false
		end,
		desc = "Hide filetype from buffer list",
	})

	vim.api.nvim_create_autocmd("FileType", {
		group = augroup_default,
		pattern = { "xml", "html", "xhtml", "css", "scss", "javascript", "lua", "dart" },
		callback = function()
			vim.opt_local.shiftwidth = 2
			vim.opt_local.tabstop = 2
		end,
		desc = "Set file specific tabstop",
	})

	local augroup_search_highlighting = vim.api.nvim_create_augroup("SearchHighlighting", { clear = true })

	vim.api.nvim_create_autocmd("CmdlineEnter", {
		group = augroup_search_highlighting,
		pattern = "/,?",
		callback = function()
			vim.opt.hlsearch = true
		end,
		desc = "Enable hlsearch on input",
	})

	vim.api.nvim_create_autocmd("CmdlineLeave", {
		group = augroup_search_highlighting,
		pattern = "/,?",
		callback = function()
			vim.opt.hlsearch = false
		end,
		desc = "Disable hlsearch on exit",
	})

	-- TODO: figure out how to do this correctly
	-- config reloading
	-- local configs = vim.api.nvim_create_augroup("Configs", { clear = true })
	--
	-- vim.api.nvim_create_autocmd("BufWritePost", {
	-- 	group = configs,
	-- 	pattern = ".nvimrc.lua",
	-- 	command = "source <afile>",
	-- })
	--
	-- vim.api.nvim_create_autocmd("BufWritePost", {
	-- 	group = configs,
	-- 	pattern = os.getenv("HOME") .. "/.config/nvim/*/*.lua",
	-- 	command = "source $MYVIMRC",
	-- })
end

return M
