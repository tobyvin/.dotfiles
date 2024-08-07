---@type LazySpec
local cmp = {
	"hrsh7th/nvim-cmp",
	event = { "InsertEnter" },
	version = false,
	dependencies = {
		"hrsh7th/cmp-path",
	},
}

function cmp:opts(opts)
	local mapping = require("cmp.config.mapping")
	local context = require("cmp.config.context")
	local default = require("cmp.config.default")()

	return vim.tbl_extend("keep", opts, {
		enabled = function()
			return default.enabled() and vim.api.nvim_get_mode()["mode"] == "c"
				or not context.in_treesitter_capture("comment")
				or not context.in_syntax_group("Comment")
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
		mapping = mapping.preset.insert({
			["<C-d>"] = mapping.scroll_docs(4),
			["<C-u>"] = mapping.scroll_docs(-4),
			["<C-Space>"] = mapping.complete(),
			["<CR>"] = mapping.confirm({ select = false }),
		}),
		sources = {
			{ name = "path" },
		},
	})
end

---@type LazySpec
local cmp_nvim_lsp = {
	"hrsh7th/cmp-nvim-lsp",
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

function cmp_nvim_lsp:init()
	local defaults = vim.lsp.protocol.make_client_capabilities()
	---@diagnostic disable-next-line: duplicate-set-field
	vim.lsp.protocol.make_client_capabilities = function()
		return require("cmp_nvim_lsp").default_capabilities(defaults)
	end
end

local M = {
	cmp,
	cmp_nvim_lsp,
}

return M
