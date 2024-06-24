local function try_lint()
	local lint = require("lint")
	local names = lint._resolve_linter_by_ft(vim.bo.filetype)

	names = vim.list_extend({}, names)

	if #names == 0 then
		vim.list_extend(names, lint.linters_by_ft["_"] or {})
	end

	vim.list_extend(names, lint.linters_by_ft["*"] or {})

	names = vim.iter(names)
		:filter(function(name)
			local linter = lint.linters[name]
			if type(linter) == "function" then
				linter = linter()
			end
			---@diagnostic disable-next-line: undefined-field
			return linter.condition == nil or linter.condition()
		end)
		:totable()

	if #names > 0 then
		lint.try_lint(names)
	end
end

---@type LazyPluginSpec
local M = {
	"mfussenegger/nvim-lint",
	opts = {
		linters_by_ft = {
			htmldjango = { "djlint" },
			lua = { "selene" },
			zsh = { "zsh" },
			systemd = { "systemdlint" },
		},
		linters = {
			selene = {
				prepend_args = {
					function()
						return string.format(
							"--config=%s",
							vim.fs.joinpath(vim.fs.root(0, "selene.toml"), "selene.toml")
						)
					end,
				},
				condition = function()
					return vim.fs.root(0, "selene.toml")
				end,
			},
		},
	},
}

function M:init()
	vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
		group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
		callback = U.debounce(100, try_lint),
	})
end

function M:config(opts)
	local lint = require("lint")
	lint.linters_by_ft = opts.linters_by_ft
	vim.iter(opts.linters):each(function(name, linter)
		if type(linter) == "table" and type(lint.linters[name]) == "table" then
			linter = vim.tbl_deep_extend("keep", linter, require("lint").linters[name] or {})
			linter.args = vim.iter({ linter.prepend_args }):flatten():rev():fold(linter.args or {}, function(args, arg)
				table.insert(args, 1, arg)
				return args
			end)
		end
		lint.linters[name] = linter
	end)
end

return M
