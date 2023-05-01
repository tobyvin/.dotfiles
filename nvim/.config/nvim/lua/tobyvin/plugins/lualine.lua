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

	local diagnostic = require("tobyvin.utils.diagnostic")

	local winbar_cond = function()
		return vim.bo.buflisted and vim.fn.bufname() ~= ""
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
					source = { diagnostic.count },
					symbols = {
						error = diagnostic.signs.error.text,
						warn = diagnostic.signs.warn.text,
						info = diagnostic.signs.info.text,
						hint = diagnostic.signs.hint.text,
					},

					diagnostics_color = {
						error = diagnostic.signs.error.hl,
						warn = diagnostic.signs.warn.hl,
						info = diagnostic.signs.info.hl,
						hint = diagnostic.signs.hint.hl,
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
