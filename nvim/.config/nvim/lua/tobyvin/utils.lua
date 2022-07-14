local M = {}

--- Wrapper for bdelete/bwipeout to add a write/discard modified selection and fire autocmd event
---@param opts ?BdeleteOpts
---@return nil
M.bdelete = function(opts)
	---@class BdeleteOpts
	---@field bufnr number Number of the buffer to target
	---@field force boolean Discard modified buffer
	---@field wipeout boolean Wipeout buffer
	opts = opts or {}

	if opts.bufnr == nil or opts.bufnr == 0 then
		opts.bufnr = vim.api.nvim_get_current_buf()
	end

	if not opts.force and vim.bo[opts.bufnr].modified then
		vim.ui.select({ "write", "discard", "abort" }, {
			prompt = string.format("No write since last change for buffer %d:", opts.bufnr),
		}, function(n)
			if n == 1 then
				vim.cmd("write")
			elseif n == 2 then
				opts.force = true
			end
		end)
	end

	local cmd = opts.wipeout and "wipeout" or "bdelete" .. opts.force and "!" or ""

	vim.api.nvim_exec_autocmds("User", { pattern = "BDeletePre", data = opts })

	if vim.api.nvim_buf_is_valid(opts.bufnr) then
		vim.cmd(string.format("%s %d", cmd, opts.bufnr))
		vim.api.nvim_exec_autocmds("User", { pattern = "BDeletePost", data = opts })
	end
end

M.spinner_frames = { "⣷", "⣯", "⣟", "⡿", "⢿", "⣻", "⣽", "⣾" }

M.diagnostic_signs = {
	error = { text = " ", texthl = "DiagnosticSignError" },
	warn = { text = " ", texthl = "DiagnosticSignWarn" },
	info = { text = " ", texthl = "DiagnosticSignInfo" },
	hint = { text = "", texthl = "DiagnosticSignHint" },
}

setmetatable(M.diagnostic_signs, {
	__index = function()
		return M.diagnostic_signs.info
	end,
})

--- Helper function to create a group of keymaps that share a common prefix and/or options. If which-key is installed
--- and group_opts.name is set, it will also create a corresponding named group.
---@param mode string|table Same mode short names as vim.keymap.set(). A list will create the group on all modes.
---@param prefix string Prefix to prepend to the lhs of all keymaps in the group.
---@param group_opts ?table Options to apply to all keymaps in this group.
---In addition to the options listed in vim.keymap.set, this table also accepts the following:
--- - name: Name of the group to create in which-key. If which-key is not installed, this does nothing.
---@return function Function to create mapping using the groups defaults.
-- TODO: Possibly add memoization to groups/subgroups using the __call metatable attribute
M.create_map_group = function(mode, prefix, group_opts)
	group_opts = group_opts or {}

	local name = group_opts.name
	group_opts.name = nil

	local status_ok, which_key = pcall(require, "which-key")
	if status_ok and name ~= nil then
		for _, m in pairs(vim.tbl_flatten({ mode })) do
			which_key.register({ [prefix] = { name = name } }, vim.tbl_extend("force", { mode = m }, group_opts))
		end
	end

	return function(lhs, rhs, opts)
		vim.keymap.set(mode, prefix .. lhs, rhs, vim.tbl_deep_extend("keep", opts or {}, group_opts))
	end
end

-- TODO: add autocommand/keymap to reload current open file/module
M.reload = function(name)
	local status_ok, plenary_reload = pcall(require, "plenary.reload")
	if status_ok then
		plenary_reload.reload_module(name)
		vim.notify("[utils.reload] '" .. name .. "' reloaded", "info", { title = "[utils] Reload" })
	end

	require(name)
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
