---@type LazyPluginSpec
local M = {
	"mfussenegger/nvim-lint",
	opts = {
		linters_by_ft = {
			django = { "djlint" },
			htmldjango = { "djlint" },
			["jinja.html"] = { "djlint" },
			markdown = { "markdownlint" },
		},
	},
}

function M:init()
	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		callback = function()
			require("lint").try_lint()
		end,
	})

	vim.api.nvim_create_autocmd({ "BufReadPost" }, {
		callback = function()
			require("lint").try_lint()
		end,
	})
end

function M:config(opts)
	local markdownlint = require("lint").linters.markdownlint
	markdownlint.args = {
		"--config",
		("%s/markdownlint/markdownlint.yaml"):format(vim.env.XDG_CONFIG_HOME),
	}

	require("lint").linters_by_ft = opts.linters_by_ft
end

return M
