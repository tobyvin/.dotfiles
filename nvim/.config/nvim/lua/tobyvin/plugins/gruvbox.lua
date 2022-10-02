local M = {}

M.setup = function()
	local status_ok, gruvbox = pcall(require, "gruvbox")
	if not status_ok then
		vim.notify("Failed to load module 'gruvbox'", vim.log.levels.ERROR)
		return
	end

	gruvbox.setup({
		bold = false,
		italic = false,
		inverse = false,
		overrides = {
			NormalFloat = { bg = "" },
			FloatBorder = { bg = "" },
			ColorColumn = { bg = "" },
			CursorLine = { bg = "" },
			CursorLineNr = { bg = "" },
			SignColumn = { bg = "" },
			GruvboxRedSign = { bg = "" },
			GruvboxGreenSign = { bg = "" },
			GruvboxYellowSign = { bg = "" },
			GruvboxBlueSign = { bg = "" },
			GruvboxPurpleSign = { bg = "" },
			GruvboxAquaSign = { bg = "" },
			GruvboxOrangeSign = { bg = "" },
		},
		transparent_mode = true,
	})

	vim.cmd([[colorscheme gruvbox]])
end

return M
