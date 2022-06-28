local utils = require("tobyvin.utils")
local M = {}

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
	local status_ok, bufdelete = pcall(require, "bufdelete")
	if not status_ok then
		vim.notify("Failed to load module 'bufdelete'", "error")
		return
	end

	local nmap = utils.create_map_group("n", "<leader>")
	nmap("c", bufdelete.bufdelete, { desc = "Close buffer" })

	local alpha_ok, alpha = pcall(require, "alpha")
	if alpha_ok then
		local augroup = vim.api.nvim_create_augroup("BufDeleteAlpha", { clear = true })

		vim.api.nvim_create_autocmd("User", {
			pattern = "BDeletePre",
			group = augroup,
			callback = function(event)
				local buffers = M.get_listed_buffers()
				for _, bufnr in ipairs(buffers) do
					local name = vim.api.nvim_buf_get_name(bufnr)
					local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
					if bufnr ~= event.buf and name ~= "" and ft ~= "Alpha" then
						return
					end
					alpha.start()
				end
			end,
		})
	end
end

return M
