local status_ok, cmp = pcall(require, "cmp")
if not status_ok then
	return
end

enabled = function()
	local context = require("cmp.config.context")

	if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
		-- disable completion in prompts
		return false
	elseif vim.api.nvim_get_mode().mode == "c" then
		-- keep command mode completion enabled when cursor is in a comment
		return true
	else
		-- disable completion in comments
		return not (context.in_treesitter_capture("comment") == true or context.in_syntax_group("Comment"))
	end
end

local get_snippets = function(args)
	require("luasnip").lsp_expand(args.body)
end

cmp.setup({
	enabled = enabled,
	completion = {
		completeopt = "menu,menuone,noinsert",
	},
	snippet = {
		expand = get_snippets,
	},
	-- TODO move mappings to which-key
	mapping = {
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-u>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
	},
	formatting = {
		format = require("lspkind").cmp_format({
			mode = "symbol_text",
			menu = {
				nvim_lsp = "[LSP]",
				luasnip = "[LuaSnip]",
				nvim_lua = "[Lua]",
				buffer = "[Buffer]",
				path = "[Path]",
			},
		}),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "path" },
		{ name = "luasnip" },
		{ name = "buffer", keyword_length = 1 },
	},
})
