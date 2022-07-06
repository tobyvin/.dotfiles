local utils = require("tobyvin.utils")
local M = {}

M.to_char = function(str)
	return str:sub(1, 1)
end

M.diff_source = function()
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.changed,
			removed = gitsigns.removed,
		}
	end
end

M.setup = function()
	local status_ok, lualine = pcall(require, "lualine")
	if not status_ok then
		return
	end

	local nvim_navic = require("nvim-navic")

	lualine.setup({
		options = {
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			globalstatus = false,
		},
		sections = {
			lualine_a = { { "mode", fmt = M.to_char } },
			lualine_b = {
				"branch",
				{ "diff", source = M.diff_source },
				{
					"diagnostics",
					sources = { "nvim_lsp" },
					symbols = {
						error = utils.diagnostic_signs.error.text,
						warn = utils.diagnostic_signs.warn.text,
						info = utils.diagnostic_signs.info.text,
						hint = utils.diagnostic_signs.hint.text,
					},
				},
			},
			lualine_c = {
				{ "filetype", icon_only = true, colored = false },
				"filename",
				{ nvim_navic.get_location, cond = nvim_navic.is_available },
			},
			lualine_x = {
				{
					"lsp_progress",
					display_components = { "lsp_client_name", "spinner", { "title", "percentage", "message" } },
					timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
					spinner_symbols = utils.spinner_frames,
				},
				"encoding",
				"fileformat",
				"filetype",
			},
		},
		tabline = {},
		extensions = { "quickfix", "man", "fzf", "nvim-dap-ui" },
	})
end

return M
