local M = {}

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

M.close_buffer = function(bufnr)
	bufnr = bufnr or 0
	local status_ok, bufdelete = pcall(require, "bufdelete")
	if status_ok then
		bufdelete.bufdelete(bufnr, true)
	else
		vim.cmd("bdelete " .. bufnr)
	end
end

M.create_map_group = function(mode, prefix, name, g_opts)
	g_opts = g_opts or {}

	local status_ok, which_key = pcall(require, "which-key")
	if status_ok and name then
		which_key.register({ [prefix] = { name = name } }, vim.tbl_extend("force", { mode = mode }, g_opts))
	end

	return function(lhs, rhs, opts)
		vim.keymap.set(mode, prefix .. lhs, rhs, vim.tbl_deep_extend("force", g_opts, opts or {}))
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
