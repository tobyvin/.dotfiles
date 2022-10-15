local M = {}

M.setup = function()
	local status_ok, nvim_navic = pcall(require, "nvim-navic")
	if not status_ok then
		vim.notify("Failed to load module 'nvim-navic'", vim.log.levels.ERROR)
		return
	end

	nvim_navic.setup({
		icons = require("lspkind").symbol_map,
	})

	vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("tobyvin_nvim-navic", { clear = true }),
		desc = "setup nvim-navic",
		callback = function(args)
			local bufnr = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)

			if client.name ~= "cssls" and client.server_capabilities.documentSymbolProvider then
				require("nvim-navic").attach(client, bufnr)
			end
		end,
	})
end

return M
