local M = {}

---@return Iter
function M.iter()
	return vim.iter(vim.api.nvim_list_bufs())
end

---@param bufnr integer
---@return boolean
function M.is_valid(bufnr)
	return vim.api.nvim_buf_is_valid(bufnr)
		and vim.api.nvim_buf_is_loaded(bufnr)
		and vim.bo[bufnr].buflisted
		and vim.bo[bufnr].buftype ~= "nofile"
end

---@param bufnr integer
---@return boolean
function M.is_invalid(bufnr)
	return not M.is_valid(bufnr)
end

---@param bufnr integer
function M.delete(bufnr, opts)
	vim.api.nvim_buf_delete(bufnr, opts or {})
end

function M.on_enter()
	if vim.fn.argc() == 0 then
		vim.bo.buftype = "nofile"
		vim.bo.bufhidden = "wipe"

		vim.keymap.set("n", "<leader>sr", U.session.read, {
			buffer = 0,
			desc = "read session",
		})
	end
	return true
end

return M
