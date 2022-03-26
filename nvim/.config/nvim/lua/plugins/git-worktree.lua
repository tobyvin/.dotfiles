local status_ok, git_worktree = pcall(require, "git-worktree")
if not status_ok then
	return
end

git_worktree.setup({
})

local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

require("telescope").load_extension("git_worktree")