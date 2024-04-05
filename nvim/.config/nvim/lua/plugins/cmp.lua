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
}

function M:config()
	local cmp = require("cmp")

	local default = require("cmp.config.default")()
	local context = require("cmp.config.context")

	local in_comment = function()
		return vim.api.nvim_get_mode()["mode"] ~= "c"
			and context.in_treesitter_capture("comment")
			and context.in_syntax_group("Comment")
	end

	cmp.setup.global({
		enabled = function()
			return default.enabled() and not in_comment()
		end,
		window = {
			completion = cmp.config.window.bordered({
				border = "single",
				scrolloff = 1,
			}),
			documentation = cmp.config.window.bordered({
				border = "single",
			}),
		},
		---@diagnostic disable-next-line: missing-fields
		formatting = {
			format = function(_, vim_item)
				vim_item.menu = nil
				return vim_item
			end,
		},
		mapping = {
			["<C-p>"] = { i = cmp.mapping.select_prev_item() },
			["<C-n>"] = { i = cmp.mapping.select_next_item() },
			["<C-d>"] = { i = cmp.mapping.scroll_docs(4) },
			["<C-u>"] = { i = cmp.mapping.scroll_docs(-4) },
			["<C-Space>"] = { i = cmp.mapping.complete({}) },
			["<CR>"] = { i = cmp.mapping.confirm() },
			["<C-y>"] = { i = cmp.mapping.confirm({ select = false }) },
			["<C-e>"] = { i = cmp.mapping.abort() },
		},
		sources = {
			{ name = "nvim_lsp" },
			{ name = "path" },
		},
	})

	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "cmdline" },
		},
	})

	cmp.setup.cmdline({ "/", "?", "@" }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer", keyword_length = 3 },
		},
	})
end

return M
