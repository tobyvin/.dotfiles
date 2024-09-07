---@type LazySpec
local M = {
	"mfussenegger/nvim-lint",
	opts = {
		linters_by_ft = {
			htmldjango = { "djlint" },
			lua = { "selene" },
			zsh = { "zsh" },
			systemd = { "systemd-analyze" },
		},
	},
}

function M:init()
	local augroup = vim.api.nvim_create_augroup("user.lint", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = augroup,
		pattern = vim.tbl_keys(self.opts.linters_by_ft),
		callback = function(args)
			vim.api.nvim_clear_autocmds({ buffer = args.buf, group = augroup })
			local debounced_lint = U.debounce(100, require("lint").try_lint)
			debounced_lint()
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
				group = augroup,
				buffer = args.buf,
				callback = function()
					debounced_lint()
				end,
				desc = "lint",
			})
		end,
		desc = "setup nvim-lint",
	})
end

function M:config(opts)
	local lint = require("lint")
	lint.linters_by_ft = opts.linters_by_ft
	table.insert(lint.linters.selene.args, function()
		local root = vim.fs.root(0, "selene.toml")
		if root then
			return string.format("--config=%s", vim.fs.joinpath(root, "selene.toml"))
		end
	end)
end

return M
