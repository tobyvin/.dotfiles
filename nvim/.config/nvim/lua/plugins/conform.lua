---@type LazyPluginSpec
local M = {
	"stevearc/conform.nvim",
	version = "*",
	event = "BufReadPre",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			css = { "prettier" },
			django = { "djlint" },
			html = { "prettier" },
			htmldjango = { "djlint" },
			["jinja.html"] = { "djlint" },
			markdown = { "prettier", "markdownlint", "cbfmt" },
			python = { "black" },
			sass = { "prettier" },
			scss = { "prettier" },
			sh = { "shfmt" },
		},
		format_on_save = false,
		format_after_save = false,
		formatters = {
			cbfmt = {
				command = "cbfmt",
				args = {
					"--stdin-filepath",
					"$FILENAME",
					"--best-effort",
					"--config",
					("%s/cbfmt/cbfmt.toml"):format(vim.env.XDG_CONFIG_HOME),
				},
				stdin = true,
			},
		},
	},
}

function M:init()
	local args = { lsp_fallback = "always" }
	vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

	vim.keymap.set({ "n", "v" }, "gqq", function()
		return require("conform").format(args)
	end, { desc = "format" })

	vim.keymap.set({ "n", "v" }, "<leader>lf", function()
		return require("conform").format(args)
	end, { desc = "format" })
end

function M:config(opts)
	require("conform.util").add_formatter_args(require("conform.formatters.prettier"), { "--prose-wrap", "always" })
	require("conform").setup(opts)
end

return M
