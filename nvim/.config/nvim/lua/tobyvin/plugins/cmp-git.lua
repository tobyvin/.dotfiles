local status_ok, cmp_git = pcall(require, "cmp_git")
if not status_ok then
	vim.notify("Failed to load module 'cmp_git'", vim.log.levels.ERROR)
	return
end

cmp_git.setup()
