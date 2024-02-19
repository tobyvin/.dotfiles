local function try_lint()
	local lint = require("lint")
	local names = lint._resolve_linter_by_ft(vim.bo.filetype)

	if #names == 0 then
		vim.list_extend(names, lint.linters_by_ft["_"] or {})
	end

	vim.list_extend(names, lint.linters_by_ft["*"] or {})

	names = vim.iter(names)
		:filter(function(name)
			local linter = lint.linters[name]
			if not linter then
				vim.notify("Linter not found: " .. name, vim.log.levels.WARN, { title = "nvim-lint" })
			end
			---@diagnostic disable-next-line: undefined-field, return-type-mismatch
			return (type(linter) == "table" and linter.condition and linter.condition()) or linter
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
			markdown = { "markdownlint" },
			zsh = { "zsh" },
		},
		linters = {
			markdownlint = {
				prepend_args = {
					"--config",
					("%s/markdownlint/markdownlint.yaml"):format(vim.env.XDG_CONFIG_HOME),
				},
			},
			selene = {
				prepend_args = {
					"--config",
					function()
						return vim.fs.find("selene.toml", {
							upward = true,
							stop = vim.uv.os_homedir(),
							path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
						})[1]
					end,
				},
				condition = function()
					return vim.fs.find("selene.toml", {
						upward = true,
						stop = vim.uv.os_homedir(),
						path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
					})[1]
				end,
			},
			shellcheck = {
				condition = function()
					return not vim.api.nvim_buf_get_name(0):match(".*/PKGBUILD$")
				end,
			},
			pkgbuildcheck = {
				extend = "shellcheck",
				cmd = "pkgbuildcheck",
				condition = function()
					return vim.api.nvim_buf_get_name(0):match(".*/PKGBUILD$")
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
		linter = vim.tbl_deep_extend("keep", linter, require("lint").linters[linter.extend or name] or {}, {
			args = {},
			prepend_args = {},
		})
		vim.iter(linter.prepend_args):rev():each(function(arg)
			table.insert(linter.args, 1, arg)
		end)
		lint.linters[name] = linter
	end)
end

return M
