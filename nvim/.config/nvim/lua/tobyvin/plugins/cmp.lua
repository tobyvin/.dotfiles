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

M.snippets = function(args)
	require("luasnip").lsp_expand(args.body)
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

M.next_item = function(fallback)
	local cmp = require("cmp")
	local luasnip = require("luasnip")
	if cmp.visible() then
		cmp.select_next_item()
	elseif luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
	elseif M.has_words_before() then
		cmp.complete()
	else
		fallback()
	end
end

M.prev_item = function(fallback)
	local cmp = require("cmp")
	local luasnip = require("luasnip")
	if cmp.visible() then
		cmp.select_prev_item()
	elseif luasnip.jumpable(-1) then
		luasnip.jump(-1)
	else
		fallback()
	end
end

M.close = function(fallback)
	local cmp = require("cmp")
	cmp.close()
	fallback()
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
			expand = M.snippets,
		},
		mapping = {
			["<Tab>"] = cmp.mapping(M.next_item),
			["<S-Tab>"] = cmp.mapping(M.prev_item),
			["<C-d>"] = cmp.mapping.scroll_docs(-4),
			["<C-u>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping(M.complete),
			["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.insert }),
			["<C-c>"] = cmp.mapping(M.close),
		},
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
end

return M
