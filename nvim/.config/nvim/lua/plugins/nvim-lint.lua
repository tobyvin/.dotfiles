---@type LazyPluginSpec
local M = {
	"mfussenegger/nvim-lint",
	opts = {
		linters_by_ft = {
			django = { "djlint" },
			htmldjango = { "djlint" },
			["jinja.html"] = { "djlint" },
			lua = { "selene" },
			markdown = { "markdownlint" },
		},
	},
}

function M:init()
	vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
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

	local selene = require("lint").linters.selene
	selene.args = {
		"--display-style",
		"json",
		function()
			local config = vim.fs.find({ "selene.toml" }, { path = vim.api.nvim_buf_get_name(0), upward = true })
			if #config > 0 then
				return string.format("--config=%s", config[1])
			end
		end,
		"-",
	}

	require("lint").linters_by_ft = opts.linters_by_ft
end

return M
