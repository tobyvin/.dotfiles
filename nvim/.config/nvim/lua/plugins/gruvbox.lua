---@type LazyPluginSpec
local M = {
	"ellisonleao/gruvbox.nvim",
	version = false,
	priority = 1000,
	opts = {
		contrast = "hard",
		transparent_mode = true,
		overrides = {
			DiffDelete = { link = "GruvboxRed" },
			DiffAdd = { link = "GruvboxGreen" },
			DiffChange = { link = "GruvboxAqua" },
			DiffText = { link = "GruvboxYellow" },
		},
	},
}

return M
