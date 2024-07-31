local function in_comment()
	return vim.api.nvim_get_mode()["mode"] ~= "c"
		and require("cmp.config.context").in_treesitter_capture("comment")
		and require("cmp.config.context").in_syntax_group("Comment")
end

---@type LazyPluginSpec
local M = {
	"hrsh7th/nvim-cmp",
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-cmdline",
	},
	opts = {
		enabled = function()
			return require("cmp.config.default")().enabled() and vim.api.nvim_get_mode()["mode"] == "c"
				or not require("cmp.config.context").in_treesitter_capture("comment")
				or not require("cmp.config.context").in_syntax_group("Comment")
		end,
		window = {
			completion = {
				border = "single",
				winhighlight = "CursorLine:Visual,Search:None",
				scrolloff = 1,
			},
			documentation = {
				border = "single",
				winhighlight = "CursorLine:Visual,Search:None",
			},
		},
		formatting = {
			format = function(_, vim_item)
				vim_item.menu = nil
				return vim_item
			end,
		},
		mapping = {
			["<C-p>"] = {
				i = function(fallback)
					if not require("cmp").select_prev_item() then
						local release = require("cmp").core:suspend()
						fallback()
						vim.schedule(release)
					end
				end,
			},
			["<C-n>"] = {
				i = function(fallback)
					if not require("cmp").select_next_item() then
						local release = require("cmp").core:suspend()
						fallback()
						vim.schedule(release)
					end
				end,
			},
			["<C-d>"] = {
				i = function(fallback)
					if not require("cmp").scroll_docs(4) then
						fallback()
					end
				end,
			},
			["<C-u>"] = {
				i = function(fallback)
					if not require("cmp").scroll_docs(-4) then
						fallback()
					end
				end,
			},
			["<C-Space>"] = {
				i = function(fallback)
					if not require("cmp").complete({}) then
						fallback()
					end
				end,
			},
			["<CR>"] = {
				i = function(fallback)
					if not require("cmp").confirm() then
						fallback()
					end
				end,
			},
			["<C-y>"] = {
				i = function(fallback)
					if not require("cmp").confirm({ select = false }) then
						fallback()
					end
				end,
			},
			["<C-e>"] = {
				i = function(fallback)
					if not require("cmp").abort() then
						fallback()
					end
				end,
			},
		},
		sources = {
			{ name = "nvim_lsp" },
			{ name = "path" },
		},
	},
}

return M
