---@class tobyvin.utils.fs
---@field sep string path seperator used by os
local M = {
	sep = vim.uv.os_uname().version:match("Windows") and "\\" or "/",
}

---Wrapper around `vim.fs.find` with sane default options.
---@param names string
---@param opts table
function M.find(names, opts)
	return vim.fs.find(
		names,
		vim.tbl_extend("keep", opts or {}, {
			path = vim.fs.dirname(vim.api.nvim_buf_get_name(opts.bufnr or 0)),
			upward = true,
		})
	)
end

---Wrapper around `vim.fn.stdpath` providing functionality similar to `vim.cmd`
---@class tobyvin.utils.fs.xdg
---@field cache fun(...: string): string
---@field config fun(...: string): string
---@field config_dirs fun(...: string): string[]
---@field data fun(...: string): string
---@field data_dirs fun(...: string): string[]
---@field log fun(...: string): string
---@field run fun(...: string): string
---@field state fun(...: string): string
M.xdg = setmetatable({}, {
	__call = function(t, dir, ...)
		return t[dir](...)
	end,
	__index = function(t, k)
		local stdpath = vim.fn.stdpath(k)

		if not stdpath then
			return
		elseif type(stdpath) == "string" then
			local xdg_dir = vim.fs.dirname(stdpath)
			t[k] = function(...)
				return vim.fs.joinpath(xdg_dir, ...)
			end
		elseif type(stdpath) == "table" then
			t[k] = function(...)
				local paths = ...
				return vim.iter(stdpath)
					:map(vim.fs.dirname)
					:map(function(p)
						return vim.fs.joinpath(p, paths)
					end)
					:totable()
			end
		end

		return t[k]
	end,
})

return M
