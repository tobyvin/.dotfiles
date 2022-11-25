local status_ok, surround = pcall(require, "surround")
if not status_ok then
	vim.notify("Failed to load module 'surround'", vim.log.levels.ERROR)
	return
end

surround.setup({
	map_insert_mode = false,
	prefix = "<C-s>",
})
