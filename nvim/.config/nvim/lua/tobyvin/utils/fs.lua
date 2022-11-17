local Path = require("plenary").path
local Reload = require("plenary").reload
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
	module_name = vim.F.if_nil(module_name, "")
	starts_with_only = vim.F.if_nil(starts_with_only, "tobyvin")

	module = package.loaded[module_name]

	Reload.reload_module(module_name, starts_with_only)

	if not pcall(require, module_name) then
		package.loaded[module_name] = module
	end

	return package.loaded[module_name]
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
