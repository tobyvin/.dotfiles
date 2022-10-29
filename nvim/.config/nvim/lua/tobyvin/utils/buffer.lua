local Path = require("plenary").path
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
		border = "single",
	}

	local win = vim.api.nvim_open_win(buf, true, opts)
	vim.api.nvim_win_set_option(win, "cursorline", true)
	vim.api.nvim_buf_set_option(buf, "modifiable", true)
	vim.api.nvim_command("$read" .. file_path)
	vim.api.nvim_buf_set_option(0, "modifiable", false)
end

M.bselect = function()
	local buffers = vim.tbl_filter(function(bufnr)
		return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
	end, vim.api.nvim_list_bufs())

	local opts = {
		prompt = "Switch buffer: ",
		format_item = function(bufnr)
			local path = vim.api.nvim_buf_get_name(bufnr)
			local relpath = Path:new(path):make_relative()
			return string.format("%s: %s", bufnr, relpath)
		end,
	}

	vim.ui.select(buffers, opts, function(_, idx)
		if idx ~= nil then
			vim.api.nvim_set_current_buf(buffers[idx])
		end
	end)
end

--- @class BdeleteOptions
--- @field force boolean Force deletion and ignore unsaved changes.
--- @field unload boolean Unloaded only, do not delete. See |:bunload|

--- Wrapper around nvim_buf_delete that preserves window layout
--- @param buffer number? Buffer handle, or 0 for current buffer
--- @param opts BdeleteOptions? Optional parameters
M.bdelete = function(buffer, opts)
	if buffer == nil then
		buffer = vim.fn.bufnr()
	end

	if opts == nil then
		opts = {
			force = false,
			unload = true,
		}
	end

	if not opts.force and vim.bo[buffer].modified then
		local bufname = vim.fn.bufname()

		return vim.ui.select({ "write", "discard", "abort" }, {
			prompt = string.format("No write since last change for buffer %s:", bufname),
			kind = "select_normal",
		}, function(_, idx)
			if idx == 1 then
				vim.cmd("write")
				M.bdelete(buffer)
			elseif idx == 2 then
				M.bdelete(buffer, { force = true })
			else
				vim.notify(
					string.format("No write since last change for buffer %d", bufname),
					vim.log.levels.ERROR,
					{ title = "Aborting..." }
				)
			end
		end)
	end

	local is_last_buffer = true
	if vim.bo[buffer].buflisted then
		---@diagnostic disable-next-line: param-type-mismatch
		local windows = vim.fn.getbufinfo(buffer)[1].windows

		for _, window in ipairs(windows) do
			local alt_buffer = vim.fn.bufnr("#")
			if vim.api.nvim_buf_is_valid(alt_buffer) and vim.bo[alt_buffer].buflisted then
				vim.api.nvim_win_set_buf(window, alt_buffer)
				is_last_buffer = false
			end
		end
	end

	if is_last_buffer and (#vim.fn.getbufinfo({ buflisted = 1 }) == 1) then
		vim.api.nvim_exec_autocmds("User", { pattern = "BDeleteLast", data = { buf = buffer } })
	end

	if vim.api.nvim_buf_is_valid(buffer) then
		vim.bo[buffer].buflisted = false
		pcall(vim.api.nvim_buf_delete, buffer, opts)
	end
end

return M
