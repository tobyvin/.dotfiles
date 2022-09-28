local utils = require("tobyvin.utils")
local M = {}

M.on_attach = function(client, bufnr)
	if client.server_capabilities.definitionProvider then
		vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
	end

	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Definition", buffer = bufnr })
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Declaration", buffer = bufnr })
	vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { desc = "Type", buffer = bufnr })
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Implementation", buffer = bufnr })
	vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "References", buffer = bufnr })
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover", buffer = bufnr })
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help", buffer = bufnr })
	vim.keymap.set("n", "<C-K>", utils.documentation.open, { desc = "Documentation", buffer = bufnr })

	utils.keymap.group("n", "<leader>l", { desc = "LSP", buffer = bufnr })
	vim.keymap.set("n", "<leader>li", "<CMD>LspInfo<CR>", { desc = "LSP info" })
	vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename", buffer = bufnr })
	vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code Action", buffer = bufnr })
	vim.keymap.set("n", "<leader>ll", vim.lsp.codelens.run, { desc = "Codelens", buffer = bufnr })

	-- disabled in favor of https://github.com/nvim-treesitter/nvim-treesitter-refactor#highlight-definitions
	require("tobyvin.lsp.highlighting").on_attach(client, bufnr)
	require("tobyvin.lsp.diagnostics").on_attach(client, bufnr)
	require("tobyvin.lsp.formatting").on_attach(client, bufnr)
	require("tobyvin.lsp.symbol").on_attach(client, bufnr)
	require("lsp_signature").on_attach()
end

M.config = function(config)
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

	return vim.tbl_deep_extend("keep", config or {}, {
		capabilities = capabilities,
		on_attach = M.on_attach,
	})
end

M.setup = function()
	require("tobyvin.lsp.handlers").setup()
	require("tobyvin.lsp.diagnostics").setup()
end

return M
