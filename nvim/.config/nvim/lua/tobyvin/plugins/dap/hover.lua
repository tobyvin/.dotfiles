local utils = require("tobyvin.utils")
local M = {}

M.hover = function()
	local widgets = require("dap.ui.widgets")
	if M.hover_available() then
		widgets.hover()
	else
		utils.hover.open()
	end
end

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
	vim.api.nvim_create_autocmd("User", {
		pattern = "DapAttach",
		callback = function()
			-- TODO: figure out why calling dap.ui.widgets.hover from util.hover is causing error
			-- vim.g.dap_hover_id = utils.hover.register(M.hover, {
			-- 	enabled = M.hover_available,
			-- 	desc = "dap",
			-- 	priority = 20,
			-- })
			vim.keymap.set("n", "K", M.hover, { desc = "hover" })
		end,
	})

	vim.api.nvim_create_autocmd("User", {
		pattern = "DapDetach",
		callback = function()
			-- utils.hover.unregister(vim.g.dap_hover_id)
			vim.keymap.set("n", "K", utils.hover.open, { desc = "hover" })
		end,
	})
end

return M
