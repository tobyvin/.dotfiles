---@type LazyPluginSpec
local M = {
	"stevearc/conform.nvim",
	version = "*",
	event = "BufReadPre",
	opts = {
		format_on_save = false,
		format_after_save = false,
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
			["*"] = { "injected" },
		},
		formatters = {
			prettier = {
				prepend_args = { "--prose-wrap", "always" },
			},
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
	vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
end

return M
