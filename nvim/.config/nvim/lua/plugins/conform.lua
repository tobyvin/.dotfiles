---@type LazyPluginSpec
local M = {
	"stevearc/conform.nvim",
	version = "*",
	event = "BufReadPre",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			css = { "stylelint" },
			django = { "djlint" },
			htmldjango = { "djlint" },
			["jinja.html"] = { "djlint" },
			markdown = { "markdownlint", "cbfmt" },
			python = { "black" },
			sass = { "stylua" },
			scss = { "stylua" },
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
	vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

	vim.keymap.set({ "n", "v" }, "gqq", function()
		return require("conform").format()
	end, { desc = "format" })

	vim.keymap.set({ "n", "v" }, "<leader>lf", function()
		return require("conform").format()
	end, { desc = "format" })
end

return M
