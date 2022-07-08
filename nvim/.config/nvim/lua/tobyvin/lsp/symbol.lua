local M = {}

M.on_attach = function(client, bufnr)
	if client.name ~= "cssls" and client.server_capabilities.documentSymbolProvider then
		require("nvim-navic").attach(client, bufnr)
	end
end

return M
