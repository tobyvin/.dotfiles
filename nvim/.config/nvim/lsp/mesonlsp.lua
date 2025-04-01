---@type vim.lsp.Config
return {
	cmd = { "mesonlsp", "--lsp" },
	filetypes = { "meson" },
	root_markers = { "meson.build", "meson_options.txt", "meson.options", ".git" },
}
