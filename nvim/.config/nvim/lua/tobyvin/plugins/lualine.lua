local utils = require("tobyvin.utils")
local M = {}

local function get_short_cwd()
	return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
end

M.to_char = function(str)
	return str:sub(1, 1)
end

M.setup = function()
	local status_ok, lualine = pcall(require, "lualine")
	if not status_ok then
		return
	end

	local winbar_cond = function()
		return vim.bo.buflisted
	end

	local workspace = {
		"branch",
		{
			"diff",
			source = function()
				local gitsigns = vim.b.gitsigns_status_dict
				if gitsigns then
					return {
						added = gitsigns.added,
						modified = gitsigns.changed,
						removed = gitsigns.removed,
					}
				end
			end,
			padding = { left = 0, right = 1 },
		},
	}

	local buffer = {
		{
			"filename",
			color = "WinBar",
			cond = winbar_cond,
		},
		{
			"diagnostics",
			source = { utils.diagnostic.buf_count },
			symbols = {
				error = utils.diagnostic.signs.error.text,
				warn = utils.diagnostic.signs.warn.text,
				info = utils.diagnostic.signs.info.text,
				hint = utils.diagnostic.signs.hint.text,
			},
			update_in_insert = true,
			color = "WinBar",
			padding = { left = 0, right = 1 },
			cond = winbar_cond,
		},
	}

	lualine.setup({
		options = {
			component_separators = "",
			section_separators = "",
			disabled_filetypes = {
				"netrw",
				"alpha",
				winbar = vim.fn.getcompletion("Neogit*", "filetype"),
			},
		},

		sections = {
			lualine_a = { { "mode", fmt = M.to_char } },
			lualine_b = workspace,
			lualine_c = {
				{
					function()
						return utils.diagnostic.indicator(nil)
					end,
					padding = { left = 1, right = 0 },
				},
				{
					"filename",
					path = 1,
				},
			},
			lualine_x = {
				"encoding",
				"fileformat",
				"filetype",
			},
		},

		inactive_sections = {
			lualine_c = { "filename" },
			lualine_x = {
				"filetype",
				"location",
			},
		},

		winbar = {
			lualine_b = buffer,
			lualine_c = {
				{
					-- Hack to prevent lualine_b from taking over the lualine_c when navic has no results
					function()
						return require("nvim-navic").get_location():gsub("^$", " ")
					end,
					color = "WinBarNC",
					cond = winbar_cond,
				},
			},
		},

		tabline = {
			lualine_b = { { "buffers", mode = 4 } },
			lualine_y = { "tabs" },
		},

		extensions = {
			"fzf",
			"man",
			"nvim-dap-ui",
			"symbols-outline",
			"quickfix",
			"toggleterm",
			{
				sections = {
					lualine_c = {
						get_short_cwd,
					},
				},
				filetypes = {
					"netrw",
				},
			},
		},
	})
end

return M
