local Path = require("plenary.path")
local Reload = require("plenary.reload")
local M = {}

-- TODO: add autocommand/keymap to reload current open file/module
M.reload = function(module_name)
	local notify_opts = { title = string.format("[utils] reload module: '%s'", module_name) }
	local reload_ok, result = pcall(Reload.reload_module, module_name)

	if not reload_ok then
		vim.notify(string.format("Failed to reload module: %s", result), vim.log.levels.ERROR, notify_opts)
		return
	end

	local require_ok, module = pcall(require, module_name)

	if not require_ok then
		vim.notify(string.format("Failed to require module: %s", result), vim.log.levels.ERROR, notify_opts)
		return
	end

	if vim.tbl_contains(module, "setup") and not pcall(module, "setup") then
		vim.notify(string.format("Failed to require module: %s", result), vim.log.levels.ERROR, notify_opts)
		return
	end

	vim.notify("Successfully reloaded module", vim.log.levels.INFO, { title = "[utils]" })
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
