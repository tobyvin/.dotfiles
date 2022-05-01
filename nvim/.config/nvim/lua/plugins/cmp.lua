local status_ok, cmp = pcall(require, "cmp")
if not status_ok then
	return
end

-- Require function for tab to work with LUA-SNIP
local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
	completion = {
		completeopt = "menu,menuone,noinsert",
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		-- Add tab support
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
		["<Tab>"] = cmp.mapping.select_next_item(),
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
		format = function(entry, vim_item)
			-- fancy icons and a name of kind
			vim_item.kind = require("lspkind").presets.default[vim_item.kind]
			-- set a name for each source
			vim_item.menu = ({
				buffer = "[Buff]",
				nvim_lsp = "[LSP]",
				luasnip = "[LuaSnip]",
				nvim_lua = "[Lua]",
				latex_symbols = "[Latex]",
			})[entry.source.name]
			return vim_item
		end,
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "path" },
		{ name = "luasnip" },
		{ name = "buffer", keyword_length = 1 },
		{ name = "calc" },
	},
	experimental = {
		-- ghost_text = true,
	},
})

-- local luasnip = require("luasnip")

-- local source_mapping = {
--   nvim_lsp = "[LSP]",
-- 	nvim_lua = "[Lua]",
-- 	path = "[Path]",
-- 	buffer = "[Buffer]",
-- 	luasnip = "[LuaSnip]",
-- 	nvim_lsp_signature_help = "[LspSignatureHelp]",
-- 	calc = "[Calc]",
-- }

-- cmp.setup({
--   snippet = {
--     expand = function(args) require('luasnip').lsp_expand(args.body) end
--   },

--   mapping = {
--     ['<C-p>'] = cmp.mapping.select_prev_item(),
--     ['<C-n>'] = cmp.mapping.select_next_item(),
--     -- Add tab support
--     ['<S-Tab>'] = cmp.mapping.select_prev_item(),
--     ['<Tab>'] = cmp.mapping.select_next_item(),
--     ['<C-d>'] = cmp.mapping.scroll_docs(-4),
--     ['<C-u>'] = cmp.mapping.scroll_docs(4),
--     ['<C-Space>'] = cmp.mapping.complete(),
--     ['<C-e>'] = cmp.mapping.close(),
--     ['<CR>'] = cmp.mapping.confirm({
--       behavior = cmp.ConfirmBehavior.Replace,
--       select = true,
--     })
--   },

-- 	formatting = {
-- 		format = function(entry, vim_item)
-- 			vim_item.kind = require("lspkind").presets.default[vim_item.kind]
-- 			local menu = source_mapping[entry.source.name]
-- 			vim_item.menu = menu
-- 			return vim_item
-- 		end,
-- 	},
--   -- Installed sources
-- 	sources = {
--     -- { name = 'path' },
-- 		{ name = "nvim_lsp" },
-- 		{ name = "nvim_lua" },
--     { name = 'path' },
-- 		{ name = "luasnip" },
-- 		{ name = "buffer", keyword_length = 1 },
--     { name = 'nvim_lsp_signature_help' },
--     { name = 'calc' },
-- 	},
-- })
