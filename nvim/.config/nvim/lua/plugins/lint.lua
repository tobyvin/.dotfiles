---@type LazySpec
local M = {
	"mfussenegger/nvim-lint",
	opts = {
		linters_by_ft = {
			htmldjango = { "djlint" },
			lua = { "selene" },
			zsh = { "zsh" },
			systemd = { "systemd-analyze" },
			awk = { "awk" },
		},
	},
}

function M:init()
	---@param ms integer
	---@param fn function
	local function debounce(ms, fn)
		local timer = vim.uv.new_timer()
		return function(...)
			local argv = { ... }
			timer:start(ms, 0, function()
				timer:stop()
				vim.schedule_wrap(fn)(unpack(argv))
			end)
		end
	end

	local augroup = vim.api.nvim_create_augroup("user.lint", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = augroup,
		pattern = vim.tbl_keys(self.opts.linters_by_ft),
		callback = function(args)
			vim.api.nvim_clear_autocmds({ buffer = args.buf, group = augroup })
			local debounced_lint = debounce(100, require("lint").try_lint)
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
