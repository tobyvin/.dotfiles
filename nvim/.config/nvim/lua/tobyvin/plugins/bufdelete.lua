local M = {
	augroup = vim.api.nvim_create_augroup("bufdelete", { clear = true }),
}

M.get_listed_buffers = function()
	local buffers = {}
	local len = 0
	for buffer = 1, vim.fn.bufnr("$") do
		if vim.fn.buflisted(buffer) == 1 then
			len = len + 1
			buffers[len] = buffer
		end
	end

	return buffers
end

M.setup = function()
	vim.api.nvim_create_autocmd("User", {
		pattern = "BDeletePre",
		group = M.augroup,
		callback = function(event)
			local found_non_empty_buffer = false
			local buffers = M.get_listed_buffers()

			for _, bufnr in ipairs(buffers) do
				if not found_non_empty_buffer then
					local name = vim.api.nvim_buf_get_name(bufnr)
					local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

					if bufnr ~= event.buf and name ~= "" and ft ~= "Alpha" then
						found_non_empty_buffer = true
					end
				end
			end

			if not found_non_empty_buffer then
				vim.cmd([[:Alpha]])
			end
		end,
	})
end

return M
