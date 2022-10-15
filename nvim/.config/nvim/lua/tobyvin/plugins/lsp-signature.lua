local M = {}

M.setup = function()
	local status_ok, lsp_signature = pcall(require, "lsp_signature")
	if not status_ok then
		return
	end

	vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("tobyvin_lsp_signature", { clear = true }),
		desc = "setup lsp_signature",
		callback = function(args)
			local bufnr = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)

			if client.server_capabilities.signatureHelpProvider then
				lsp_signature.on_attach({
					bind = true,
					hint_prefix = "> ",
					hi_parameter = "IncSearch",
					handler_opts = {
						border = "rounded",
					},
				}, bufnr)
			end
		end,
	})
end

return M
