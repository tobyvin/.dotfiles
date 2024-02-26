---@diagnostic disable: missing-fields
---@type LazyPluginSpec
local M = {
	"hrsh7th/nvim-cmp",
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lsp-document-symbol",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-cmdline",
		"Dosx001/cmp-commit",
		"rcarriga/cmp-dap",
		"davidsierradz/cmp-conventionalcommits",
		{
			"petertriho/cmp-git",
			ft = "gitcommit",
			dependencies = { "nvim-lua/plenary.nvim" },
			config = true,
		},
		{
			"David-Kunz/cmp-npm",
			dependencies = { "nvim-lua/plenary.nvim" },
			config = true,
		},
		{
			"saadparwaiz1/cmp_luasnip",
			dependencies = {
				{
					"L3MON4D3/LuaSnip",
					version = "*",
					build = "make install_jsregexp",
				},
			},
		},
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
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},
		window = {
			completion = cmp.config.window.bordered({
				border = "single",
				scrolloff = 1,
			}),
			documentation = cmp.config.window.bordered({
				border = "single",
			}),
		},
		formatting = {
			format = function(_, vim_item)
				vim_item.menu = nil
				return vim_item
			end,
		},
		mapping = cmp.mapping.preset.insert({
			["<Tab>"] = { i = cmp.mapping.select_next_item() },
			["<S-Tab>"] = { i = cmp.mapping.select_prev_item() },
			["<C-d>"] = { i = cmp.mapping.scroll_docs(4) },
			["<C-u>"] = { i = cmp.mapping.scroll_docs(-4) },
			["<C-Space>"] = { i = cmp.mapping.complete({}) },
			["<CR>"] = { i = cmp.mapping.confirm() },
		}),
		sources = {
			{ name = "nvim_lsp" },
			{ name = "nvim_lsp_signature_help" },
			{ name = "luasnip" },
			{ name = "path" },
		},
	})

	local cmd_mapping = cmp.mapping.preset.cmdline({
		["<C-Space>"] = { c = cmp.mapping.complete({}) },
		["<C-e>"] = { c = cmp.mapping.abort() },
	})

	cmp.setup.cmdline(":", {
		mapping = cmd_mapping,
		sources = {
			{ name = "cmdline", max_item_count = 10 },
		},
	})

	cmp.setup.cmdline({ "/", "?", "@" }, {
		mapping = cmd_mapping,
		sources = {
			{ name = "nvim_lsp_document_symbol", max_item_count = 10, group_index = 1 },
			{ name = "buffer", keyword_length = 3, max_item_count = 10, group_index = 2 },
		},
	})

	cmp.setup.filetype({ "tex", "bib", "markdown" }, {
		sources = {
			{ name = "buffer", keyword_length = 3 },
		},
	})

	cmp.setup.filetype("gitcommit", {
		sources = {
			{ name = "git" },
			{ name = "commit" },
			{ name = "conventionalcommits" },
		},
	})

	cmp.setup.filetype("json", {
		sources = {
			{ name = "npm" },
		},
	})

	cmp.setup.filetype("toml", {
		sources = {
			{ name = "crates" },
		},
	})

	cmp.setup.filetype("dap-repl", {
		sources = {
			{ name = "dap" },
		},
	})
end

return M
