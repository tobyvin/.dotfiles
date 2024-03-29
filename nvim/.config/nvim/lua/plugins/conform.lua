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
	local args = { lsp_fallback = "always" }
	vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

	vim.keymap.set({ "n", "v" }, "gqq", function()
		return require("conform").format(args)
	end, { desc = "format" })

	vim.keymap.set({ "n", "v" }, "<leader>lf", function()
		return require("conform").format(args)
	end, { desc = "format" })
end

return M
