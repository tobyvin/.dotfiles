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
		linters = {
			markdownlint = {
				config = "markdownlint.yaml",
			},
			selene = {
				config = "selene.toml",
			},
		},
	},
}

local function prepend(tbl, items)
	for i, arg in ipairs(items or {}) do
		table.insert(tbl, i, arg)
	end
	return tbl
end

local function with_config(args, filename)
	return prepend(args, {
		function()
			local config = unpack(vim.fs.find(filename, {
				path = vim.api.nvim_buf_get_name(0),
				upward = true,
			})) or ("%s/%s"):format(vim.fs.basename(filename), filename)
			return vim.fn.filereadable(config) == 1 and string.format("--config=%s", config) or ""
		end,
	})
end

function M:init()
	local linters = self.opts.linters or {}
	self.opts.linters = setmetatable({}, {
		__index = function(t, k)
			local ok, linter = pcall(require, "lint.linters." .. k)
			if ok and linters[k] then
				t[k] = vim.tbl_extend("force", { args = {} }, linter, linters[k] or {})
				prepend(with_config(t[k].args, t[k].config), t[k].prepend_args)
			end
			return t[k]
		end,
	})

	vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
		callback = function()
			require("lint").try_lint()
		end,
	})
end

function M:config(opts)
	require("lint").linters = opts.linters
	require("lint").linters_by_ft = opts.linters_by_ft
end

return M
