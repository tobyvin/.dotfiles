local background = vim.opt.background:get()
local theme = require("lualine.themes.gruvbox_" .. background)

theme = vim.tbl_deep_extend("force", theme, {
	normal = {
		b = "StatusLine",
		c = "StatusLineNC",
	},
	insert = {
		b = "StatusLine",
		c = "StatusLineNC",
	},
	visual = {
		b = "StatusLine",
		c = "StatusLineNC",
	},
	replace = {
		b = "StatusLine",
		c = "StatusLineNC",
	},
	command = {
		b = "StatusLine",
		c = "StatusLineNC",
	},
	inactive = {
		b = "StatusLineNC",
		c = "StatusLineNC",
	},
})

return theme
