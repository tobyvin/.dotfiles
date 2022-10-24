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

	local diff = {
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
	}

	local diagnostics = {
		"diagnostics",
		sources = { utils.diagnostic.count },
		symbols = {
			error = utils.diagnostic.signs.error.text,
			warn = utils.diagnostic.signs.warn.text,
			info = utils.diagnostic.signs.info.text,
			hint = utils.diagnostic.signs.hint.text,
		},
		update_in_insert = true,

		padding = { left = 0, right = 1 },
	}

	local workspace = {
		{ "b:gitsigns_head", icon = "" },
		diff,
		diagnostics,
	}

	local buffer = {
		{
			"filetype",
			colored = false,
			icon_only = true,
			padding = { left = 1, right = 0 },
		},
		"filename",
		vim.tbl_extend("force", diagnostics, { source = { utils.diagnostic.buf_count }, colored = false }),
		{
			require("nvim-navic").get_location,
			color = { bg = "" },
		},
		{
			"string.format(' ')",
			color = { bg = "" },
		},
	}
	local filetypes = vim.fn.getcompletion("", "filetype")
	local disabled = vim.tbl_filter(function(ft)
		return string.match(ft, "^Neogit.*") ~= nil
	end, filetypes)
	table.insert(disabled, "gitcommit")

	lualine.setup({
		options = {
			refresh = {
				statusline = 200,
			},
			component_separators = "",
			section_separators = "",
			disabled_filetypes = {
				"netrw",
				"alpha",
				"",
				winbar = disabled,
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
			lualine_c = buffer,
		},

		tabline = {
			lualine_b = { "buffers" },
			lualine_y = { "tabs" },
		},

		extensions = {
			"quickfix",
			"man",
			"fzf",
			"nvim-dap-ui",
			"symbols-outline",
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
