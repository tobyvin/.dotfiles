vim.filetype.add({
	extension = {
		eml = "mail",
		ron = "ron",
		zsh = "sh",
	},
	filename = {
		["PKGBUILD"] = "PKGBUILD",
	},
	pattern = {
		[".*%.conf"] = { "confini", { priority = -math.huge } },
	},
})
