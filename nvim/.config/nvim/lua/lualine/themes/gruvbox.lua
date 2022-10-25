local status_ok, colors = pcall(require, "gruvbox.palette")
if not status_ok then
	return require("lualine.themes.gruvbox_dark")
end

local theme = {
	normal = {
		a = { fg = colors.dark0, bg = colors.light4, gui = "bold" },
		b = "StatusLine",
		c = "StatusLineNC",
	},
	insert = {
		a = { fg = colors.dark0, bg = colors.bright_blue, gui = "bold" },
		b = "StatusLine",
		c = "StatusLineNC",
	},
	visual = {
		a = { fg = colors.dark0, bg = colors.bright_orange, gui = "bold" },
		b = "StatusLine",
		c = "StatusLineNC",
	},
	replace = {
		a = { fg = colors.dark0, bg = colors.bright_red, gui = "bold" },
		b = "StatusLine",
		c = "StatusLineNC",
	},
	command = {
		a = { fg = colors.dark0, bg = colors.bright_green, gui = "bold" },
		b = "StatusLine",
		c = "StatusLineNC",
	},
	inactive = {
		a = { fg = colors.light4, bg = colors.dark1, gui = "bold" },
		b = "StatusLineNC",
		c = "StatusLineNC",
	},
}

return theme
