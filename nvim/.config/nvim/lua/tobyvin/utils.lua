local M = {
	dashboard = require("tobyvin.utils.dashboard"),
	session = require("tobyvin.utils.session"),
	dap = require("tobyvin.utils.dap"),
	sep = vim.uv.os_uname().version:match("Windows") and "\\" or "/",
}

---@param ... string
M.join = function(...)
	return table.concat({ ... }, M.sep)
end

function M.inspect(v)
	print(vim.inspect(v))
	return v
end

function M.lazy_require(modname)
	return setmetatable({}, {
		__index = function(_, k)
			return function(...)
				return require(modname)[k](...)
			end
		end,
	})
end

---@param ms integer
---@param fn function
function M.debounce(ms, fn)
	local timer = vim.loop.new_timer()
	return function(...)
		local argv = { ... }
		timer:start(ms, 0, function()
			timer:stop()
			vim.schedule_wrap(fn)(unpack(argv))
		end)
	end
end

---Register callback to run when a lsp server matching a filter attaches to a buffer
---@param on_attach fun(client: lsp.Client, buffer: integer): boolean|nil
---@param filter vim.lsp.get_clients.filter|nil
function M.on_attach(on_attach, filter)
	vim.api.nvim_create_autocmd("LspAttach", {
		desc = "on client attach",
		callback = function(args)
			local bufnr = args.buf ---@type number
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			filter = filter or {}

			if
				client
				and (filter.id == nil or client.id == filter.id)
				and (filter.name == nil or client.name == filter.name)
				and (filter.bufnr == nil or bufnr == filter.bufnr)
				and (filter.method == nil or client.supports_method(filter.method, { bufnr = bufnr }))
			then
				on_attach(client, bufnr)
			end
		end,
	})
end

---Merges two or more highlights groups into a new highlight group.
---
---**Note**: This will overwrite any existing group named <name>. If you would like to both merge
---*and* overwrite a group, specify it both as <name>, as well as in the list of groups to merge.
---
---E.g. extend_hl(ns, "Normal", "Normal", "Special", { fg = "#333333" }, { other_ns, "Specific" })
---@param ns integer Namespace
---@param name string name of new hightlight group. ---If you want to groups into an existing group, add <name> to the list of groups to merge.*
---@param ... string|table|{ [1]: integer, [2]: string|table } Two or more highlight group names, anonymous highlight definitions, or tuples in the form of { namespace, name|definition }
function M.extend_hl(ns, name, ...)
	local hl = {}

	for _, arg in pairs({ ... }) do
		local hl_name_or_val, hl_ns, hl_val
		if
			vim.tbl_islist(arg --[[@as table]])
		then
			hl_ns, hl_name_or_val = arg[1], arg[2]
		else
			hl_ns, hl_name_or_val = ns, arg --[[@as string|table]]
		end

		if type(hl_name_or_val) == "string" then
			hl_val = vim.api.nvim_get_hl(hl_ns, { name = hl_name_or_val, link = false })
		else
			hl_val = hl_name_or_val
		end

		hl = vim.tbl_extend("keep", hl, hl_val)
	end

	vim.api.nvim_set_hl(ns, name, hl)
end

---@class stdpath
---@field cache fun(...: string): string
---@field config fun(...: string): string
---@field config_dirs fun(...: string): string
---@field data fun(...: string): string
---@field data_dirs fun(...: string): string
---@field log fun(...: string): string
---@field run fun(...: string): string
---@field state fun(...: string): string
M.stdpath = setmetatable({}, {
	__call = function(t, dir, ...)
		return t[dir](...)
	end,
	__index = function(t, dir)
		local value = vim.fn.stdpath(dir)
		if not value or type(value) == "table" then
			t[dir] = value
		else
			t[dir] = function(...)
				return table.concat({ vim.fs.dirname(value), ... }, M.sep)
			end
		end

		return t[dir]
	end,
})

---Searches upward from <bufnr>'s name for <filename>. If not found, returns the first existing
---fallback or nil if none exist
---@param bufnr integer
---@param filename string
---@param ... string? fallback paths
function M.find(bufnr, filename, ...)
	local results = vim.fs.find(filename, {
		upward = true,
		stop = vim.uv.os_homedir(),
		path = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)),
	})
	vim.list_extend(results, { ... })

	return vim.iter(results)
		:map(function(f)
			if not f:starts("/") then
				f = M.join(vim.fn.stdpath("config") --[[@as string]], f)
			end
			return f
		end)
		:find(function(f)
			return vim.fn.filereadable(f) == 1
		end)
end

return M
