local M = {}

M.get_visual_range = function()
	local start_pos = vim.fn.getpos("v")
	local end_pos = vim.fn.getcurpos()
	return { start_pos[2], end_pos[2] }
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
M.kill = function(cmd, force)
	local winid = vim.fn.win_getid()
	local bufnr = vim.fn.winbufnr(winid)

	if not force and vim.bo[bufnr].modified then
		return M.modified_prompt_retry(M[cmd])
	end

	vim.api.nvim_exec_autocmds("User", { pattern = cmd })

	if (string.sub(cmd, 1, 1) == "b" and vim.api.nvim_buf_is_valid(bufnr)) or vim.api.nvim_win_is_valid(winid) then
		vim.cmd(cmd .. (force and "!" or ""))
	end
end

---@param force boolean
M.bdelete = function(force)
	M.kill("bdelete", force)
end

---@param force boolean
M.bwipeout = function(force)
	M.kill("bwipeout", force)
end

---@param force boolean
M.close = function(force)
	M.kill("close", force)
end

---@param force boolean
M.quit = function(force)
	M.kill("quit", force)
end

---@param force boolean
M.tabclose = function(force)
	local cmd = "tabclose"
	if #vim.api.nvim_list_tabpages() == 1 then
		cmd = "qall"
	end
	vim.cmd(cmd .. (force and "!" or ""))
end

return M
