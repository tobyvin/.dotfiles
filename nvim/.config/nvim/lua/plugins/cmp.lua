local function i_map_with(name, call_fallback, ...)
	local args = { ... }
	return {
		i = function(fallback)
			if not require("cmp")[name](unpack(args)) then
				call_fallback(fallback)
			end
		end,
	}
end

local function i_map(name, ...)
	return i_map_with(name, function(fb)
		fb()
	end, ...)
end

---@type LazySpec
local cmp = {
	"hrsh7th/nvim-cmp",
	event = { "InsertEnter" },
	enabled = false,
	version = false,
	dependencies = {
		"hrsh7th/cmp-path",
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
			["<C-p>"] = i_map_with("select_prev_item", function(fallback)
				local release = require("cmp").core:suspend()
				fallback()
				vim.schedule(release)
			end),
			["<C-n>"] = i_map_with("select_next_item", function(fallback)
				local release = require("cmp").core:suspend()
				fallback()
				vim.schedule(release)
			end),
			["<C-d>"] = i_map("scroll_docs", 4),
			["<C-u>"] = i_map("scroll_docs", -4),
			["<C-Space>"] = i_map("complete", {}),
			["<CR>"] = i_map("confirm"),
			["<C-y>"] = i_map("confirm", { select = false }),
			["<C-e>"] = i_map("abort"),
		},
		sources = {
			{ name = "path" },
		},
	},
}

---@type LazySpec
local cmp_nvim_lsp = {
	"hrsh7th/cmp-nvim-lsp",
	enabled = false,
	opts = {},
	specs = {
		{
			"hrsh7th/nvim-cmp",
			opts = function(_, opts)
				opts.sources = opts.sources or {}
				table.insert(opts.sources, {
					name = "nvim_lsp",
				})
			end,
		},
	},
}

local M = {
	cmp,
	cmp_nvim_lsp,
}

return M
