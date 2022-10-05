local utils = require("tobyvin.utils")
local lsp = {
	handlers = require("tobyvin.lsp.handlers"),
	highlighting = require("tobyvin.lsp.highlighting"),
	diagnostics = require("tobyvin.lsp.diagnostics"),
	formatting = require("tobyvin.lsp.formatting"),
	symbol = require("tobyvin.lsp.symbol"),
}

lsp.on_attach = function(client, bufnr)
	if client.server_capabilities.definitionProvider then
		vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
	end

	vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover", buffer = bufnr })
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help", buffer = bufnr })
	vim.keymap.set("n", "<leader>k", utils.documentation.open, { desc = "Documentation", buffer = bufnr })
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Definition", buffer = bufnr })
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Declaration", buffer = bufnr })
	vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { desc = "Type", buffer = bufnr })
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Implementation", buffer = bufnr })
	vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "References", buffer = bufnr })

	utils.keymap.group("n", "gp", { desc = "Preview", buffer = bufnr })
	vim.keymap.set("n", "gpd", lsp.handlers.preview.definition, { desc = "Definition", buffer = bufnr })
	vim.keymap.set("n", "gpD", lsp.handlers.preview.declaration, { desc = "Declaration", buffer = bufnr })
	vim.keymap.set("n", "gpt", lsp.handlers.preview.type_definition, { desc = "Type", buffer = bufnr })
	vim.keymap.set("n", "gpi", lsp.handlers.preview.implementation, { desc = "Implementation", buffer = bufnr })
	vim.keymap.set("n", "gpr", lsp.handlers.preview.references, { desc = "References", buffer = bufnr })

	utils.keymap.group("n", "<leader>l", { desc = "LSP", buffer = bufnr })
	vim.keymap.set("n", "<leader>li", "<CMD>LspInfo<CR>", { desc = "LSP info" })
	vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename", buffer = bufnr })
	vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code Action", buffer = bufnr })
	vim.keymap.set("n", "<leader>ll", vim.lsp.codelens.run, { desc = "Codelens", buffer = bufnr })

	-- disabled in favor of https://github.com/nvim-treesitter/nvim-treesitter-refactor#highlight-definitions
	lsp.highlighting.on_attach(client, bufnr)
	lsp.diagnostics.on_attach(client, bufnr)
	lsp.formatting.on_attach(client, bufnr)
	lsp.symbol.on_attach(client, bufnr)
	require("lsp_signature").on_attach()

	vim.api.nvim_exec_autocmds("User", { pattern = "LspAttach", data = { client_id = client.id } })
end

lsp.config = function(config)
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

	return vim.tbl_deep_extend("keep", config or {}, {
		capabilities = capabilities,
		on_attach = lsp.on_attach,
	})
end

lsp.setup = function()
	lsp.handlers.setup()
	require("tobyvin.lsp.diagnostics").setup()
end

return lsp
