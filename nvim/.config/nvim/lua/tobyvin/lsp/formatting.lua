local M = {
	augroup_format = vim.api.nvim_create_augroup("Format", { clear = true }),
}

M.toggle_format = function()
	vim.b.auto_format = not vim.b.auto_format
	vim.notify("Auto-formatter " .. (vim.b.auto_format and "en" or "dis") .. "abled", "Info")
end

M.on_attach = function(client, bufnr)
	local nmap = require("tobyvin.utils").create_map_group("n", "<leader>l", { desc = "LSP", buffer = bufnr })

	if client.server_capabilities.documentFormattingProvider then
		vim.b.auto_format = true

		vim.api.nvim_buf_create_user_command(
			bufnr,
			"ToggleAutoFormat",
			M.toggle_format,
			{ desc = "Toggle auto-format" }
		)
		vim.api.nvim_buf_create_user_command(bufnr, "Format", vim.lsp.buf.format, { nargs = "*", desc = "Format" })

		nmap("f", vim.lsp.buf.format, { desc = "Format" })
		nmap("F", M.toggle_format, { desc = "Toggle auto-format" })

		vim.api.nvim_clear_autocmds({ group = M.augroup_format, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = M.augroup_format,
			buffer = bufnr,
			callback = function()
				if M.auto_format_enabled then
					vim.lsp.buf.format()
				end
			end,
			desc = "Auto-format",
		})
	end

	local vmap = require("tobyvin.utils").create_map_group("v", "<leader>l", { desc = "LSP", buffer = bufnr })

	if client.server_capabilities.documentRangeFormattingProvider then
		vim.api.nvim_buf_create_user_command(
			bufnr,
			"FormatRange",
			vim.lsp.buf.range_formatting,
			{ nargs = "*", desc = "Format range" }
		)

		vmap("f", vim.lsp.buf.range_formatting, { desc = "Format range" })
	end
end

return M
