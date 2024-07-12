local M = {
	buf = require("tobyvin.utils.buf"),
	dap = require("tobyvin.utils.dap"),
	dashboard = require("tobyvin.utils.dashboard"),
	fs = require("tobyvin.utils.fs"),
	lsp = require("tobyvin.utils.lsp"),
	session = require("tobyvin.utils.session"),
	ui = require("tobyvin.utils.ui"),
}

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
	local timer = vim.uv.new_timer()
	return function(...)
		local argv = { ... }
		timer:start(ms, 0, function()
			timer:stop()
			vim.schedule_wrap(fn)(unpack(argv))
		end)
	end
end

function M.system(...)
	local s = vim.system(...)
	--- @param obj vim.SystemObj
	--- @param cmd string[]
	--- @param opts vim.SystemOpts|nil)
	--- @param on_exit function|nil
	---@diagnostic disable-next-line: inject-field
	s.pipe = function(obj, cmd, opts, on_exit)
		opts = vim.tbl_extend("keep", opts or {}, { stdin = obj:wait().stdout })
		return M.system(cmd, opts, on_exit)
	end

	--- @param obj vim.SystemObj
	--- @param cmd string[]
	--- @param opts vim.SystemOpts|nil)
	--- @param on_exit function|nil
	---@diagnostic disable-next-line: inject-field
	s.try_pipe = function(obj, cmd, opts, on_exit)
		if vim.fn.executable(cmd[1]) ~= 1 then
			cmd = { "cat" }
		end
		---@diagnostic disable-next-line: undefined-field
		return obj:pipe(cmd, opts, on_exit)
	end

	return s
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
		if type(arg) ~= "string" and vim.islist(arg) then
			hl_ns, hl_name_or_val = arg[1], arg[2]
		else
			hl_ns, hl_name_or_val = ns, arg
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

return M
