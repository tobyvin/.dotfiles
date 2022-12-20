local M = {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"kyazdani42/nvim-web-devicons",
		"SmiteshP/nvim-navic",
	},
}

function M.config()
	local lualine = require("lualine")

	local utils = require("tobyvin.utils")

	local get_short_cwd = function()
		return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
	end

	local to_char = function(str)
		return str:sub(1, 1)
	end

	local winbar_cond = function()
		return vim.bo.buflisted
	end

	local git = {
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
	}

	local workspace = {
		{
			function()
				return utils.diagnostic
					.indicator(nil)
					:gsub("DiagnosticSignError", "lualine_b_diagnostics_error_normal")
					:gsub("DiagnosticSignWarn", "lualine_b_diagnostics_warn_normal")
					:gsub("DiagnosticSignInfo", "lualine_b_diagnostics_info_normal")
					:gsub("DiagnosticSignHint", "lualine_b_diagnostics_hint_normal")
			end,
			padding = { left = 1, right = 0 },
			color = "StatusLineNC",
		},
		{
			"filename",
			path = 1,
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
			lualine_a = { { "mode", fmt = to_char } },
			lualine_b = git,
			lualine_c = workspace,
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
