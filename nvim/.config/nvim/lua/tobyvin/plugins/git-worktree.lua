local M = {}

M.setup = function()
	local status_ok, git_worktree = pcall(require, "git-worktree")
	if not status_ok then
		vim.notify("Failed to load module 'git-worktree'", vim.log.levels.ERROR)
		return
	end

	git_worktree.setup({})
end

return M
