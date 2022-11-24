local log = require("plenary.log").new({ plugin = "notify" })
local levels = {}
for k, v in pairs(vim.log.levels) do
	levels[v] = k:lower()
	levels[k] = k:lower()
	levels[k:lower()] = k:lower()
end

setmetatable(log, {
	__call = function(t, msg, level, opts)
		local log_msg = msg
		if opts and opts.title then
			log_msg = string.format("%s: %s", opts.title, log_msg)
		end

		local level_name = vim.F.if_nil(levels[level], "info")
		pcall(t[level_name], log_msg)

		vim.api.nvim_exec_autocmds("User", {
			pattern = "Notify",
			data = { msg, level, opts },
		})
	end,
})

vim.notify = log

local M = {
	options = require("tobyvin.options"),
	autocmds = require("tobyvin.autocmds"),
	keymaps = require("tobyvin.keymaps"),
	plugins = require("tobyvin.plugins"),
	diagnostic = require("tobyvin.diagnostic"),
	lsp = require("tobyvin.lsp"),
}

M.setup = function()
	M.options.setup()
	M.autocmds.setup()
	M.keymaps.setup()
	M.plugins.setup()
	M.diagnostic.setup()
	M.lsp.setup()
end

return M
