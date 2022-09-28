local M = {}

-- TODO: add autocommand/keymap to reload current open file/module
M.reload = function(name)
	local notify_opts = { title = string.format("[utils] reload module: '%s'", name) }
	local status_ok, result = pcall(require, "plenary.reload")
	if status_ok then
		status_ok, result = pcall(result.reload_module, name)
	end

	if status_ok then
		status_ok, result = pcall(require, name)
	end

	if status_ok then
		vim.notify("Successfully reloaded module", vim.log.levels.INFO, { title = "[utils]" })
	else
		vim.notify(string.format("Failed to reload module: %s", result), vim.log.levels.ERROR, notify_opts)
	end
end

M.file_exists = function(file)
	local ok, err, code = os.rename(file, file)
	if not ok and code == 13 then
		return true
	end
	return ok, err
end

M.isdir = function(path)
	return M.file_exists(path .. "/")
end

return M
