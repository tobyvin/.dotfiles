local M = {}

-- Common kill function for bdelete and bwipeout
M._bdelete = function(wipeout, bufnr, force)
	-- If buffer is modified and force isn't true, print error and abort

	if type(bufnr) == "boolean" and force == nil then
		force = bufnr
		bufnr = nil
	end

	if bufnr == 0 or bufnr == nil then
		bufnr = vim.api.nvim_get_current_buf()
	end

	local base_cmd = "bdelete"

	if wipeout then
		base_cmd = "bwipeout"
	end

	local cmd
	if not force and vim.bo[bufnr].modified then
		vim.ui.select({ "write", "discard" }, {
			prompt = string.format("No write since last change for buffer %d:", bufnr),
		}, function(n)
			if n == 1 then
				vim.cmd("write")
				cmd = base_cmd
			elseif n == 2 then
				cmd = base_cmd .. "!"
			else
				vim.notify("[bdelete] Aborting...")
			end
		end)
	end

	if not cmd then
		return
	end

	-- Get list of windows IDs with the buffer to close
	local windows = vim.tbl_filter(function(win)
		return vim.api.nvim_win_get_buf(win) == bufnr
	end, vim.api.nvim_list_wins())

	-- Get list of valid and listed buffers
	local buffers = vim.tbl_filter(function(buf)
		return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
	end, vim.api.nvim_list_bufs())

	-- If there is only one buffer (which has to be the current one), Neovim will automatically
	-- create a new buffer on :bd.
	-- For more than one buffer, pick the next buffer (wrapping around if necessary)
	if buffers ~= nil and #buffers > 1 then
		local next_buffer = vim.fn.winbufnr(vim.fn.winnr("#"))

		if not next_buffer then
			for i, v in ipairs(buffers) do
				if v == bufnr then
					next_buffer = buffers[i % #buffers + 1]
					break
				end
			end
		end

		for _, win in ipairs(windows) do
			vim.api.nvim_win_set_buf(win, next_buffer)
		end
	end

	-- Check if buffer still exists, to ensure the target buffer wasn't killed
	-- due to options like bufhidden=wipe.
	if vim.api.nvim_buf_is_valid(bufnr) then
		-- Execute the BDeletePre and BDeletePost autocommands before and after deleting the buffer
		vim.api.nvim_exec_autocmds("User", { pattern = "BDeletePre" })
		vim.cmd(string.format("%s %d", cmd, bufnr))
		vim.api.nvim_exec_autocmds("User", { pattern = "BDeletePost" })
	end
end

M.bdelete = function(...)
	M._bdelete(false, ...)
end

M.bwipeout = function(...)
	M._bdelete(true, ...)
end

M.setup = function()
	vim.api.nvim_create_user_command("Bdelete", M.bdelete, { nargs = "?", bang = true, desc = "Bdelete" })
	vim.api.nvim_create_user_command("Bwipeout", M.bwipeout, { nargs = "?", bang = true, desc = "Bwipeout" })
end

return M
