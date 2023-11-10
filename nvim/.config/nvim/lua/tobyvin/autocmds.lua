local augroup = vim.api.nvim_create_augroup("tobyvin", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ macro = true })
	end,
	desc = "Highlight yank",
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = vim.api.nvim_create_augroup("session", { clear = true }),
	callback = function()
		-- HACK: Workaround for bug preventing restoration of current/alt buffers.
		-- See: https://github.com/stevearc/oil.nvim/issues/29
		if vim.bo.filetype == "oil" then
			require("oil").close()
		end

		if vim.fn.argc() == 0 and #vim.fn.getbufinfo({ buflisted = 1, bufloaded = 1 }) > 0 then
			pcall(U.session.write)
		end
	end,
	desc = "write session on vim exit",
})

vim.api.nvim_create_autocmd("VimEnter", {
	group = augroup,
	callback = function()
		if vim.fn.argc() == 0 then
			local curr_buf = vim.api.nvim_get_current_buf()
			U.dashboard.setup()
			vim.api.nvim_buf_delete(curr_buf, {})
		end
	end,
	desc = "show dashboard on startup",
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

vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	callback = function(args)
		-- HACK: Workaround for writing oil.nvim buffers
		if not vim.bo[args.buf].buflisted or vim.bo.filetype == "oil" then
			return
		end

		local file = vim.loop.fs_realpath(args.match) or args.match
		local parent = vim.fn.fnamemodify(file, ":h")

		if not parent then
			return
		end

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
