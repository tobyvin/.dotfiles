local status_ok, cmp = pcall(require, "cmp")
if not status_ok then
	vim.notify("Failed to load module 'cmd'", vim.log.levels.ERROR)
	return
end

local lsp = require("tobyvin.lsp")

local enabled = function()
	local ctx = require("cmp.config.context")
	local enabled = require("cmp.config.default")().enabled() or require("cmp_dap").is_dap_buffer()
	if vim.api.nvim_get_mode().mode ~= "c" then
		enabled = enabled and not ctx.in_treesitter_capture("comment")
		enabled = enabled and not ctx.in_syntax_group("Comment")
	end
	return enabled
end

local expand_snip = function(args)
	require("luasnip").lsp_expand(args.body)
end

lsp.default_config = vim.tbl_extend("force", lsp.default_config, {
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

cmp.setup({
	enabled = enabled,
	window = {
		completion = cmp.config.window.bordered({ border = "single" }),
		documentation = cmp.config.window.bordered({ border = "single" }),
	},
	snippet = {
		expand = expand_snip,
	},
	mapping = cmp.mapping.preset.cmdline({
		["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
		["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
		["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
		["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "s" }),
		["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "s" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "s" }),
		["<C-e>"] = cmp.mapping(cmp.mapping.close(), { "i", "s" }),
		["<CR>"] = cmp.mapping(
			cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Insert,
				-- select = true,
			}),
			{ "i", "s" }
		),
	}),
	ghost_text = true,
	sources = {
		{ name = "nvim_lsp", group_index = 1 },
		{ name = "nvim_lua", group_index = 1 },
		{ name = "path", group_index = 1 },
		{ name = "luasnip", group_index = 1 },
		{ name = "dap", group_index = 1 },
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

cmp.setup.cmdline(":", {
	sources = {
		{ name = "cmdline_history", max_item_count = 10 },
		{ name = "cmdline", max_item_count = 10 },
	},
})

cmp.setup.cmdline("/", {
	sources = {
		{ name = "buffer", max_item_count = 10 },
		{ name = "cmdline_history", max_item_count = 10 },
	},
})

cmp.setup.cmdline("?", {
	sources = {
		{ name = "buffer", max_item_count = 10 },
		{ name = "cmdline_history", max_item_count = 10 },
	},
})

cmp.setup.cmdline("@", {
	sources = {
		{ name = "cmdline_history", max_item_count = 10 },
	},
})
