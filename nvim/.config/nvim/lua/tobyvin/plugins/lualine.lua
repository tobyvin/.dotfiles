local M = {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = {
		"kyazdani42/nvim-web-devicons",
		"SmiteshP/nvim-navic",
	},
}

function M.config()
	local lualine = require("lualine")

	local utils = require("tobyvin.utils.diagnostic")

	local winbar_cond = function()
		return vim.bo.buflisted and (vim.fn.bufname() ~= "" or require("nvim-navic").is_available())
	end

	lualine.setup({
		options = {
			component_separators = "",
			section_separators = "",
		},

		sections = {
			lualine_a = { {
				"mode",
				fmt = function(str)
					return str:sub(1, 1)
				end,
			} },
			lualine_b = {
				{
					"branch",
					color = "StatusLine",
				},
				{
					"diff",
					source = function()
						local gitsigns = vim.b["gitsigns_status_dict"]
						if gitsigns then
							return {
								added = gitsigns.added,
								modified = gitsigns.changed,
								removed = gitsigns.removed,
							}
						end
					end,
					padding = { left = 0, right = 1 },
					color = "StatusLine",
				},
			},
			lualine_c = {
				{
					"diagnostics",
					source = { utils.count },
					symbols = {
						error = utils.signs.error.text,
						warn = utils.signs.warn.text,
						info = utils.signs.info.text,
						hint = utils.signs.hint.text,
					},

					diagnostics_color = {
						error = utils.signs.error.hl,
						warn = utils.signs.warn.hl,
						info = utils.signs.info.hl,
						hint = utils.signs.hint.hl,
					},
					update_in_insert = true,
					color = "StatusLineNC",
				},
			},
			lualine_x = {
				{
					"encoding",
					color = "StatusLineNC",
				},
				{
					"fileformat",
					color = "StatusLineNC",
				},
				{
					"filetype",
					color = "StatusLineNC",
				},
			},
		},

		inactive_sections = {
			lualine_c = {
				{
					"filename",
					path = 1,
					color = "StatusLineNC",
				},
			},
			lualine_x = {
				{
					"filetype",
					color = "StatusLineNC",
				},
				{
					"location",
					color = "StatusLineNC",
				},
			},
		},

		winbar = {
			lualine_b = {
				{
					"filename",
					cond = winbar_cond,
					color = "WinBar",
				},
			},
			lualine_c = {
				{
					function()
						return require("nvim-navic").get_location()
					end,
					-- Hack to prevent lualine_b from taking over the lualine_c when navic has no results
					fmt = function(value)
						return value:gsub("^$", " ")
					end,
					color = "WinBarNC",
					cond = winbar_cond,
				},
			},
		},

		tabline = {
			lualine_b = {
				{
					function()
						return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
					end,
					color = "StatusLine",
				},
			},
			lualine_c = {
				{
					"filename",
					path = 1,
					shorten = true,
					file_status = false,
					color = "StatusLineNC",
				},
			},
			lualine_y = {
				{
					"tabs",
					color = "StatusLine",
				},
			},
		},

		extensions = {
			"fzf",
			"man",
			"nvim-dap-ui",
			"symbols-outline",
			"quickfix",
			"toggleterm",
		},
	})
end

return M
