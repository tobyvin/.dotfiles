local success, ferris = pcall(require, "ferris")
if not success then
	return
end

ferris.setup({
	url_handler = vim.ui.open,
})
