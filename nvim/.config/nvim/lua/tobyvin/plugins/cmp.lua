local M = {}

M.enabled = function()
	local ctx = require("cmp.config.context")
	local enabled = require("cmp.config.default")().enabled() or require("cmp_dap").is_dap_buffer()
	if vim.api.nvim_get_mode().mode ~= "c" then
		enabled = enabled and not ctx.in_treesitter_capture("comment")
		enabled = enabled and not ctx.in_syntax_group("Comment")
	end
	return enabled
end

M.has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

M.complete = function(fallback)
	local cmp = require("cmp")
	if cmp.visible() then
		cmp.confirm({ behavior = cmp.ConfirmBehavior.insert, select = true })
	elseif M.has_words_before() then
		cmp.complete()
	else
		fallback()
	end
end

M.expand_snip = function(args)
	require("luasnip").lsp_expand(args.body)
end

M.next_snip = function(fallback)
	local luasnip = require("luasnip")
	if luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
	else
		fallback()
	end
end

M.prev_snip = function(fallback)
	local luasnip = require("luasnip")
	if luasnip.in_snippet() and luasnip.jumpable(-1) then
		luasnip.jump(-1)
	else
		fallback()
	end
end

M.close = function(fallback)
	local cmp = require("cmp")
	if cmp.visible() then
		cmp.close()
	else
		fallback()
	end
end

M.setup = function()
	local status_ok, cmp = pcall(require, "cmp")
	if not status_ok then
		vim.notify("Failed to load module 'cmd'", "error")
		return
	end

	cmp.setup({
		enabled = M.enabled,
		snippet = {
			expand = M.expand_snip,
		},
		mapping = cmp.mapping.preset.cmdline({
			-- ["<Tab>"] = cmp.mapping(M.next_snip, { "i", "s" }),
			-- ["<S-Tab>"] = cmp.mapping(M.prev_snip, { "i", "s" }),
			-- ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
			-- ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
			-- ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "s" }),
			-- ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "s" }),
			-- ["<C-Space>"] = cmp.mapping(M.complete, { "i", "s" }),
			-- ["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = false }), { "i", "s" }),
			-- ["<C-e>"] = cmp.mapping(M.close),
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
					select = true,
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

	-- TODO: fix the default completion menu from showing on the cmdline
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
end

return M
