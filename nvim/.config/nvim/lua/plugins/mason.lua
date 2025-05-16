---@type LazySpec
local M = {
	"williamboman/mason.nvim",
	build = ":MasonUpdate",
	lazy = false,
	opts = {
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	},
}

---Install python package using pip
---@param package Package Mason base package
---@param module string Python module to install
---@return fun()
local function pip_install(package, module)
	return vim.schedule_wrap(function()
		local res = vim.system({
			vim.fs.joinpath(vim.env.MASON, "packages", package.name, "venv/bin/python"),
			"-m",
			"pip",
			"install",
			module,
		}, { text = true }):wait()
		if res.code == 0 then
			local msg = string.format([["%s" was successfully installed.]], module)
			vim.notify(msg, vim.log.levels.INFO, { title = "mason.nvim" })
		else
			local msg = string.format([[Could not install "%s"]], module)
			vim.notify(msg, vim.log.levels.ERROR, { title = "mason.nvim" })
			error(res.stderr)
		end
	end)
end

function M:config(opts)
	require("mason").setup(opts)
	require("mason-registry").refresh(function()
		local mdformat = require("mason-registry").get_package("mdformat")
		mdformat:on("install:success", pip_install(mdformat, "mdformat-gfm"))
	end)
end

return M
