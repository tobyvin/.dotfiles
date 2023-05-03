local M = {
	"nvim-lualine/lualine.nvim",
	cond = not vim.g.started_by_firenvim,
	event = "VeryLazy",
	dependencies = {
		"kyazdani42/nvim-web-devicons",
	},
}

function M.config()
	local lualine = require("lualine")

	local diagnostic = require("tobyvin.utils.diagnostic")

	lualine.setup({
		options = {
			component_separators = "",
			section_separators = "",
			ignore_focus = {
				"TelescopePrompt",
				"TelescopeResults",
			},
		},

		sections = {
			lualine_a = {
				{
					"mode",
					fmt = function(str)
						return str:sub(1, 1)
					end,
				},
			},
			lualine_b = {
				"branch",
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
				},
			},
			lualine_x = {
				"encoding",
				"fileformat",
				"filetype",
			},
		},

		inactive_sections = {
			lualine_c = {
				{
					"filename",
					path = 1,
				},
			},
			lualine_x = {
				"filetype",
				"location",
			},
		},
		tabline = {
			lualine_b = {
				function()
					return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
				end,
			},
			lualine_c = {
				{
					"filename",
					path = 1,
					shorten = true,
					file_status = false,
				},
			},
			lualine_y = {
				"tabs",
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

function M:deactivate()
	require("lualine").setup({
		options = {
			refresh = {
				statusline = 0,
				tabline = 0,
				winbar = 0,
			},
		},
	})
	vim.opt_local.statusline = ""
	vim.opt_local.winbar = ""
	vim.opt_local.tabline = ""
end

return M
