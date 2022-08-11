---@diagnostic disable: missing-parameter
local M = {}

M.diagnostic_signs = {
	hint = { text = " ", texthl = "DiagnosticSignHint" },
	info = { text = " ", texthl = "DiagnosticSignInfo" },
	warn = { text = " ", texthl = "DiagnosticSignWarn" },
	error = { text = " ", texthl = "DiagnosticSignError" },
}

setmetatable(M.diagnostic_signs, {
	__index = function(t, k)
		if type(k) == "number" then
			local levels = { "hint", "info", "warn", "error" }
			return levels[k]
		end

		local fmt_k = k:gsub("warning", "warn"):lower()
		if t[fmt_k] ~= nil then
			return t[fmt_k]
		end

		return t[k]
	end,
})

M.debug_signs = {
	breakpoint = { text = " ", texthl = "debugBreakpoint" },
	condition = { text = "ﳁ ", texthl = "debugBreakpoint" },
	rejected = { text = " ", texthl = "debugBreakpoint" },
	logpoint = { text = " ", texthl = "debugBreakpoint" },
	stopped = { text = " ", texthl = "debugBreakpoint", linehl = "debugPC", numhl = "debugPC" },
}

M.progress_signs = {
	complete = { text = " ", texthl = "diffAdded" },
	spinner = { text = { "⣷", "⣯", "⣟", "⡿", "⢿", "⣻", "⣽", "⣾" }, texthl = "DiagnosticSignInfo" },
}

M.diagnostics_indicator = function(diagnostics_count)
	local tbl = {}
	for level, count in pairs(diagnostics_count) do
		table.insert(tbl, M.diagnostic_signs[level].text .. count)
	end
	return table.concat(tbl, " ")
end

M.diagnostics_count = function(bufnr)
	local items = {}
	for i, level in ipairs({ "hint", "info", "warn", "error" }) do
		local count = #vim.diagnostic.get(bufnr, { severity = i })
		if count > 0 then
			items[level] = count
		end
	end
	return items
end

M.diagnostics_str = function(bufnr, highlight)
	return M.diagnostics_indicator(M.diagnostics_count(bufnr))
end

M.update_spinner = function(client_id, token)
	local notif_data = M.get_notif_data(client_id, token)

	if notif_data.spinner then
		local new_spinner = (notif_data.spinner + 1) % #M.progress_signs.spinner.text
		notif_data.spinner = new_spinner

		notif_data.notification = vim.notify(nil, nil, {
			hide_from_history = true,
			icon = M.progress_signs.spinner.text[new_spinner],
			replace = notif_data.notification,
		})

		vim.defer_fn(function()
			M.update_spinner(client_id, token)
		end, 100)
	end
end

M.hover = function()
	if vim.fn.expand("%:t") == "Cargo.toml" then
		require("crates").show_popup()
	else
		vim.lsp.buf.hover()
	end
end

M.docs = function()
	local filetype = vim.bo.filetype
	if vim.tbl_contains({ "vim", "help" }, filetype) then
		vim.cmd("help " .. vim.fn.expand("<cword>"))
	elseif vim.tbl_contains({ "man" }, filetype) then
		vim.cmd("Man " .. vim.fn.expand("<cword>"))
	elseif vim.tbl_contains({ "rust" }, filetype) then
		require("rust-tools.external_docs").open_external_docs()
	else
		M.hover()
	end
end

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

---@param force boolean
M.tabclose = function(force)
	local cmd = "tabclose"
	if #vim.api.nvim_list_tabpages() == 1 then
		cmd = "qall"
	end
	vim.cmd(cmd .. (force and "!" or ""))
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

M.client_notifs = {}

M.get_notif_data = function(client_id, token)
	if not M.client_notifs[client_id] then
		M.client_notifs[client_id] = {}
	end

	if not M.client_notifs[client_id][token] then
		M.client_notifs[client_id][token] = {}
	end

	return M.client_notifs[client_id][token]
end

M.format_title = function(title, client)
	if type(client) == "table" then
		client = client.name
	end
	return client .. (#title > 0 and ": " .. title or "")
end

M.format_message = function(message, percentage)
	return (percentage and percentage .. "%\t" or "") .. (message or "")
end

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
