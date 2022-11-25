local status_ok, cmp = pcall(require, "cmp")
if not status_ok then
	vim.notify("Failed to load module 'cmd'", vim.log.levels.ERROR)
	return
end

local lsp = require("tobyvin.lsp")
local luasnip = require("luasnip")
local default = require("cmp.config.default")()
local context = require("cmp.config.context")
local cmp_dap = require("cmp_dap")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

local in_comment = function()
	return vim.api.nvim_get_mode().mode ~= "c"
		and context.in_treesitter_capture("comment")
		and context.in_syntax_group("Comment")
end

local enabled = function()
	return (default.enabled() or cmp_dap.is_dap_buffer()) and not in_comment()
end

local expand_snip = function(args)
	luasnip.lsp_expand(args.body)
end

cmp.setup.global({
	enabled = enabled,
	window = {
		completion = cmp.config.window.bordered({ border = "single" }),
		documentation = cmp.config.window.bordered({ border = "single" }),
	},
	snippet = {
		expand = expand_snip,
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
		{ name = "luasnip" },
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

cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
	sources = {
		{ name = "dap" },
	},
})

cmp.setup.filetype({
	"tex",
	"bib",
	"sh",
	"zsh",
	"xml",
	"markdown",
}, {
	sources = {
		{ name = "buffer", keyword_length = 3, group_index = 2 },
	},
})

cmp.setup.filetype({ "tex", "bib" }, {
	sources = {
		{ name = "latex_symbols" },
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

lsp.default_config = vim.tbl_extend("force", lsp.default_config, {
	capabilities = cmp_nvim_lsp.default_capabilities(),
})
