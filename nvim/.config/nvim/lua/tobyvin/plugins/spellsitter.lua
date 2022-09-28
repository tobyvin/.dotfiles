local M = {}

M.setup = function()
	local status_ok, spellsitter = pcall(require, "spellsitter")
	if not status_ok then
		vim.notify("Failed to load module 'spellsitter'", vim.log.levels.ERROR)
		return
	end

	spellsitter.setup()
end

return M
