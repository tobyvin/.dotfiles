local M = {}

M.setup = function()
	local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
	if not status_ok then
		vim.notify("Failed to load module 'mason-lspconfig'", "error")
		return
	end

	mason_lspconfig.setup()
end

return M
