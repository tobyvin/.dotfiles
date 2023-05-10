vim.filetype.add({
	extension = {
		eml = "mail",
		ron = "ron",
		zsh = "sh",
	},
	pattern = {
		[".*%.conf"] = { "confini", { priority = -math.huge } },
	},
})
