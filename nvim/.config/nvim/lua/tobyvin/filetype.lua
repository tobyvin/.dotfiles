vim.filetype.add({
	extension = {
		eml = "mail",
		ron = "ron",
		zsh = "sh",
	},
	pattern = {
		[".*%.conf"] = { "dosini", { priority = -math.huge } },
	},
})
