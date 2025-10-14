local success, colorizer = pcall(require, "colorizer")
if not success then
	return
end

colorizer.setup({
	filetypes = {
		"css",
		"scss",
		"sass",
		"javascript",
		"html",
		"htmldjango",
	},
	user_default_options = {
		mode = "virtualtext",
		xterm = true,
	},
	virtualtext_inline = true,
})
