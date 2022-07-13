local M = {}

M.setup = function()
	local status_ok, git_conflict = pcall(require, "git-conflict")
	if not status_ok then
		vim.notify("Failed to load module 'git_conflict'", "error")
		return
	end

	git_conflict.setup({
		disable_diagnostics = true,
		highlights = {
			incoming = "diffText",
			current = "diffAdd",
		},
	})
end

return M
