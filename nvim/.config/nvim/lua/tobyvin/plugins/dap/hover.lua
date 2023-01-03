local utils = require("tobyvin.utils")
local M = {}

M.hover_available = function()
	local session = require("dap").session()
	if not session then
		return false
	end
	local frame = session.current_frame or {}
	---@diagnostic disable-next-line: missing-parameter
	local scopes = frame.scopes or {}
	local expression = vim.fn.expand("<cexpr>")
	for _, s in pairs(scopes) do
		local variable = s.variables and s.variables[expression]
		if variable then
			return true
		end
	end
	return session:evaluate(expression, function(err)
		if not err then
			return true
		end
		return false
	end)
end

M.setup = function()
	local dap_hover_id
	vim.api.nvim_create_autocmd("User", {
		pattern = "DapAttach",
		callback = function()
			dap_hover_id = utils.hover.register(require("dap.ui.widgets").hover, {
				desc = "dap",
				enabled = M.hover_available,
				priority = 20,
			})
		end,
	})

	vim.api.nvim_create_autocmd("User", {
		pattern = "DapDetach",
		callback = function()
			utils.hover.unregister(dap_hover_id)
		end,
	})
end

return M
