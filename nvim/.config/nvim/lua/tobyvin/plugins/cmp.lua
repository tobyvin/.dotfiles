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
		"petertriho/cmp-git",
		"Dosx001/cmp-commit",
		"davidsierradz/cmp-conventionalcommits",
		"saecki/crates.nvim",
		"kdheepak/cmp-latex-symbols",
	},
}

function M.config()
	local cmp = require("cmp")

	local default = require("cmp.config.default")()
	local context = require("cmp.config.context")

	local in_comment = function()
		return vim.api.nvim_get_mode().mode ~= "c"
			and context.in_treesitter_capture("comment")
			and context.in_syntax_group("Comment")
	end

	local enabled = function()
		return (default.enabled() or require("cmp_dap").is_dap_buffer()) and not in_comment()
	end

	cmp.setup.global({
		enabled = enabled,
		window = {
			completion = cmp.config.window.bordered({ border = "single" }),
			documentation = cmp.config.window.bordered({ border = "single" }),
		},
		mapping = cmp.mapping.preset.insert({
			["<Tab>"] = { i = cmp.mapping.select_next_item() },
			["<S-Tab>"] = { i = cmp.mapping.select_prev_item() },
			["<C-d>"] = { i = cmp.mapping.scroll_docs(4) },
			["<C-u>"] = { i = cmp.mapping.scroll_docs(-4) },
			["<C-Space>"] = { i = cmp.mapping.complete() },
			["<CR>"] = { i = cmp.mapping.confirm() },
		}),
		sources = {
			{ name = "nvim_lsp" },
			{ name = "nvim_lsp_signature_help" },
			{ name = "path" },
			{ name = "dap" },
		},
	})

	local cmd_mapping = cmp.mapping.preset.cmdline({
		["<C-Space>"] = { c = cmp.mapping.complete() },
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
			{ name = "latex_symbols" },
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
end

return M
