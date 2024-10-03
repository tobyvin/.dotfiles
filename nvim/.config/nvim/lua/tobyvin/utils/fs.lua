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

function M.getflist()
	return _G.flist
end

function M.setflist(flist, mode)
	flist = flist or {}
	if _G.flist == nil or mode == "a" then
		_G.flist = vim.tbl_extend("keep", flist, {
			title = "flist",
			items = {},
		})
	else
		vim.list_extend(_G.flist.items, flist.items or {})
		flist.items = nil
		_G.flist = vim.tbl_extend("force", _G.flist, flist)
	end
end

function M.fopen()
	error("Not implemented")
end

function M.fnext(opts)
	opts = vim.tbl_extend("keep", opts or {}, {
		count = 1,
		bang = false,
	})

	if not _G.flist or #_G.flist.items == 0 then
		error("No files")
	elseif _G.flist.idx == #_G.flist.items then
		error("No more items")
	end

	_G.flist.idx = _G.flist.idx and _G.flist.idx + opts.count or 1
	local filename = _G.flist.items[_G.flist.idx].filename
	vim.cmd.edit({ filename, bang = opts.bang })
end

function M.fprev(opts)
	opts = vim.tbl_extend("keep", opts or {}, {
		count = 1,
		bang = false,
	})

	if not _G.flist or #_G.flist.items == 0 then
		error("No files")
	elseif _G.flist.idx == 1 then
		error("No more items")
	end

	_G.flist.idx = _G.flist.idx and _G.flist.idx - opts.count or 1
	local filename = _G.flist.items[_G.flist.idx].filename
	vim.cmd.edit({ filename, bang = opts.bang })
end

function M.flist(dir)
	local bufname = vim.api.nvim_buf_get_name(0)
	if not dir then
		if bufname then
			dir = vim.fs.dirname(bufname)
		else
			dir = vim.uv.cwd()
		end
	end

	local flist = {
		title = dir,
		items = {},
	}

	for name, type in vim.iter(vim.fs.dir(dir)) do
		if type == "file" then
			local filename = vim.fs.joinpath(dir, name)
			table.insert(flist.items, {
				filename = filename,
				text = name,
			})
			if filename == bufname then
				flist.idx = #flist.items
			end
		end
	end

	return flist
end

return M
