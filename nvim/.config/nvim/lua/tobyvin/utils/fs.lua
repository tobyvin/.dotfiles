local Job = require("plenary.job")
local Path = require("plenary.path")
local Reload = require("plenary.reload")
local M = {}

M.config_path = function(package)
	local rel_path = Path:new(vim.fn.stdpath("config")):normalize(vim.env.HOME)
	return Path:new(vim.env.HOME, ".dotfiles", package, rel_path)
end

M.module_from_path = function(path)
	path = vim.F.if_nil(path, vim.api.nvim_buf_get_name(0))
	path = Path:new(path)
	local lua_dir = M.config_path("nvim"):joinpath("lua").filename
	if path:exists() and not path:is_dir() and string.match(path.filename, "^" .. lua_dir) then
		return path:normalize(lua_dir):gsub(".lua$", ""):gsub("/", ".")
	end
end

M.reload = function(module_name, starts_with_only)
	module_name = vim.F.if_nil(module_name, M.module_from_path())
	starts_with_only = vim.F.if_nil(starts_with_only, "tobyvin")

	Reload.reload_module(module_name, starts_with_only)

	local notify_opts = { title = string.format("[utils] reload: '%s'", module_name) }
	local status_ok, module = pcall(require, module_name)
	if not status_ok then
		vim.notify("Failed to require module", vim.log.levels.ERROR, notify_opts)
	end
	vim.notify("Reloaded module", vim.log.levels.INFO, notify_opts)
	return module
end

M.select_exe = function(cwd, callback)
	cwd = vim.fn.expand(vim.F.if_nil(cwd, vim.fn.getcwd()))

	local command_list = (function()
		if 1 == vim.fn.executable("fd") then
			return { "fd", "--type", "x", "--hidden" }
		elseif 1 == vim.fn.executable("fdfind") then
			return { "fdfind", "--type", "x", "--hidden" }
		elseif 1 == vim.fn.executable("find") and vim.fn.has("win32") == 0 then
			return { "find", ".", "-type", "f", "--executable" }
		end
	end)()

	local command = table.remove(command_list, 1)

	local items = Job:new({
		command = command,
		args = command_list,
		cwd = cwd,
		enable_recording = true,
	}):sync()

	vim.ui.select(items, { kind = "executables" }, callback)
end

M.shorten_path = function(filename, len)
	local path = Path:new(filename)
	local short_len = 0
	for _, part in pairs(path:parents()) do
		short_len = math.max(short_len, #part)
	end
	filename = path:make_relative()
	while short_len > 0 and vim.fn.strlen(filename) > len - 10 do
		filename = Path:new(path:make_relative()):shorten(short_len, { -1, 1 })
		short_len = short_len - 1
	end
	return filename
end

return M
