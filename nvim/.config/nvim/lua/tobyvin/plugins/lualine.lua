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
		},
	}

	local filetypes = vim.fn.getcompletion("", "filetype")
	local neogit = vim.tbl_filter(function(ft)
		return string.match(ft, "^Neogit.*") ~= nil
	end, filetypes)

	lualine.setup({
		options = {
			component_separators = "",
			section_separators = "",
			disabled_filetypes = {
				"netrw",
				"alpha",
				"",
				winbar = vim.tbl_extend("keep", neogit, { "gitcommit" }),
			},
		},

		sections = {
			lualine_a = { { "mode", fmt = M.to_char } },
			lualine_b = workspace,
			lualine_c = {
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
				},
			},
		},

		tabline = {
			lualine_b = { "buffers" },
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
