local M = {}

---@param retry fun(force:boolean?):nil
M.modified_prompt_retry = function(retry)
	local bufname = vim.fn.bufname(vim.fn.bufname())

	vim.ui.select({ "write", "discard", "abort" }, {
		prompt = string.format("No write since last change for buffer %s:", bufname),
		kind = "select_normal",
	}, function(_, idx)
		if idx == 1 then
			vim.cmd("write")
			retry()
		elseif idx == 2 then
			retry(true)
		else
			vim.notify(
				string.format("No write since last change for buffer %d", bufname),
				vim.log.levels.ERROR,
				{ title = "Aborting..." }
			)
		end
	end)
end

---@param cmd string vim command
---@param force boolean
M.win_buf_kill = function(cmd, force)
	local winid = vim.fn.win_getid()
	local bufnr = vim.fn.winbufnr(winid)

	if not force and vim.bo[bufnr].modified then
		return M.modified_prompt_retry(M[cmd])
	end

	vim.api.nvim_exec_autocmds("User", { pattern = cmd })

	if (string.sub(cmd, 1, 1) == "b" and vim.api.nvim_buf_is_valid(bufnr)) or vim.api.nvim_win_is_valid(winid) then
		vim.cmd(cmd .. (force and "!" or ""))
	end

	vim.api.nvim_exec_autocmds("User", { pattern = cmd })
end

---@param force boolean
M.bdelete = function(force)
	M.win_buf_kill("bdelete", force)
end

---@param force boolean
M.bwipeout = function(force)
	M.win_buf_kill("bwipeout", force)
end

---@param force boolean
M.close = function(force)
	M.win_buf_kill("close", force)
end

---@param force boolean
M.quit = function(force)
	M.win_buf_kill("quit", force)
end

M.escape = function()
	local key = "<ESC>"
	vim.api.nvim_replace_termcodes(key, true, false, true)
	vim.api.nvim_feedkeys(key, "x", true)
	-- vim.api.nvim_input("<ESC>")
	-- vim.wait(100, function()
	-- 	return "n" == vim.fn.mode()
	-- end)
end

M.get_visual_range = function()
	local start_pos = vim.fn.getpos("v")
	local end_pos = vim.fn.getcurpos()
	return { start_pos[2], end_pos[2] }
	-- return { { line = start_pos[2], col = start_pos[3] }, { line = end_pos[2], col = end_pos[3] } }
end

M.spinner_frames = { "⣷", "⣯", "⣟", "⡿", "⢿", "⣻", "⣽", "⣾" }

M.diagnostic_signs = {
	error = { text = " ", texthl = "DiagnosticSignError" },
	warn = { text = " ", texthl = "DiagnosticSignWarn" },
	info = { text = " ", texthl = "DiagnosticSignInfo" },
	hint = { text = "", texthl = "DiagnosticSignHint" },
}

M.debug_signs = {
	breakpoint = { text = "", texthl = "debugBreakpoint" },
	condition = { text = "ﳁ", texthl = "debugBreakpoint" },
	rejected = { text = "", texthl = "debugBreakpoint" },
	logpoint = { text = "", texthl = "debugBreakpoint" },
	stopped = { text = "", texthl = "debugBreakpoint", linehl = "debugPC", numhl = "debugPC" },
}

setmetatable(M.diagnostic_signs, {
	__index = function()
		return M.diagnostic_signs.info
	end,
})

--- Helper function to create a group of keymaps that share a common prefix and/or options.
---@param mode string|table Same mode short names as vim.keymap.set(). A list will create the group on all modes.
---@param group_lhs string Prefix to prepend to the lhs of all keymaps in the group.
---@param group_opts ?table Options to apply to all keymaps in this group. (Same as options listed in vim.keymap.set)
---@return function Function to create mapping using the groups defaults.
-- TODO: Possibly add memoization to groups/subgroups using the __call metatable attribute
M.create_map_group = function(mode, group_lhs, group_opts)
	group_opts = group_opts or {}

	local name = group_opts.name

	local desc = group_opts.desc
	group_opts.desc = nil

	local status_ok, which_key = pcall(require, "which-key")
	if status_ok and desc ~= nil then
		for _, m in pairs(vim.tbl_flatten({ mode })) do
			which_key.register({ [group_lhs] = { name = desc } }, vim.tbl_extend("force", { mode = m }, group_opts))
		end
	end

	return function(lhs, rhs, opts)
		vim.keymap.set(mode, group_lhs .. lhs, rhs, vim.tbl_deep_extend("keep", opts or {}, group_opts))
	end
end

-- TODO: add autocommand/keymap to reload current open file/module
M.reload = function(name)
	local notify_opts = { title = string.format("[utils] reload module: '%s'", name) }
	local status_ok, result = pcall(require, "plenary.reload")
	if status_ok then
		status_ok, result = pcall(result.reload_module, name)
	end

	if status_ok then
		status_ok, result = pcall(require, name)
	end

	if status_ok then
		vim.notify("Successfully reloaded module", vim.log.levels.INFO, { title = "[utils]" })
	else
		vim.notify(string.format("Failed to reload module: %s", result), vim.log.levels.ERROR, notify_opts)
	end
end

M.popup = function(file_path)
	local buf = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

	local width = vim.api.nvim_get_option("columns")
	local height = vim.api.nvim_get_option("lines")

	local win_height = math.ceil(height * 0.8 - 4)
	local win_width = math.ceil(width * 0.8)

	local row = math.ceil((height - win_height) / 2 - 1)
	local col = math.ceil((width - win_width) / 2)

	local opts = {
		style = "minimal",
		relative = "editor",
		width = win_width,
		height = win_height,
		row = row,
		col = col,
		border = "rounded",
	}

	local win = vim.api.nvim_open_win(buf, true, opts)
	vim.api.nvim_win_set_option(win, "cursorline", true)
	vim.api.nvim_buf_set_option(buf, "modifiable", true)
	vim.api.nvim_command("$read" .. file_path)
	vim.api.nvim_buf_set_option(0, "modifiable", false)
end

--- count existing buffers
---@param filter function predicate used to filter counted buffers
---@return table
M.count_bufs_by_type = function(filter)
	local count = { normal = 0, acwrite = 0, help = 0, nofile = 0, nowrite = 0, quickfix = 0, terminal = 0, prompt = 0 }
	local buftypes = vim.api.nvim_list_bufs()
	for _, bufname in pairs(buftypes) do
		if filter == nil or filter(bufname) then
			local buftype = vim.api.nvim_buf_get_option(bufname, "buftype")
			buftype = buftype ~= "" and buftype or "normal"
			count[buftype] = count[buftype] + 1
		end
	end
	return count
end

M.file_exists = function(file)
	local ok, err, code = os.rename(file, file)
	if not ok and code == 13 then
		return true
	end
	return ok, err
end

M.isdir = function(path)
	return M.file_exists(path .. "/")
end

return M
