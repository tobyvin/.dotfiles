local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end

local to_char = function(str)
	return str:sub(1, 1)
end

local nvim_gps = function()
	local status_gps_ok, gps = pcall(require, "nvim-gps")
	if not status_gps_ok or gps.get_location() == "error" then
		return ""
	else
		return gps.get_location()
	end
end

local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

lualine.setup({
	options = {
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "alpha" },
	},
	sections = {
		lualine_a = { { "mode", fmt = to_char } },
		lualine_c = {
			{ nvim_gps, cond = hide_in_width },
		},
	},
	tabline = {},
	extensions = { "quickfix", "fzf", "fugitive", "toggleterm", "neo-tree" },
})
