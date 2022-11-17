local log = require("plenary.log").new({ plugin = "notify" })
for k, v in pairs(vim.log.levels) do
	log[v + 1] = log[k:lower()]
end

setmetatable(log, {
	__call = function(t, msg, level, opts)
		pcall(t[level], msg, level, opts)
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
