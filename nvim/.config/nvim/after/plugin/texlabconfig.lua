require("texlabconfig").setup({})
vim.lsp.config("texlab", {
	settings = {
		texlab = {
			forwardSearch = {
				args = {
					"--synctex-editor-command",
					[[nvim-texlabconfig -file '%%%{input}' -line %%%{line} -server ]] .. vim.v.servername,
					"--synctex-forward",
					"%l:1:%f",
					"%p",
				},
			},
		},
	},
})
