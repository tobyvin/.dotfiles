local utils = require("tobyvin.utils")
local lsp = require("tobyvin.lsp")
local M = {
	codelldb = "/usr/lib/codelldb/adapter/codelldb",
	liblldb = "/usr/lib/codelldb/lldb/lib/liblldb.so",
}

M.setup = function()
	local status_ok, rust_tools = pcall(require, "rust-tools")
	if not status_ok then
		vim.notify("Failed to load module 'rust-tools'", vim.log.levels.ERROR)
		return
	end

	lsp.configs["rust-analyzer"].on_attach = function(client, bufnr)
		lsp.on_attach(client, bufnr)

		local runnables = rust_tools.runnables.runnables
		local debuggables = rust_tools.debuggables.debuggables
		local open_cargo_toml = rust_tools.open_cargo_toml.open_cargo_toml
		local external_docs = rust_tools.external_docs.open_external_docs

		utils.keymap.group("n", "<leader>r", { desc = "Run" })
		vim.keymap.set("n", "<leader>rr", runnables, { desc = "Runnables", buffer = bufnr })
		vim.keymap.set("n", "<leader>rd", debuggables, { desc = "Debug", buffer = bufnr })
		vim.keymap.set("n", "<leader>ro", open_cargo_toml, { desc = "Open Cargo.toml", buffer = bufnr })

		utils.documentation.register("rust", external_docs)
	end

	rust_tools.setup({
		server = lsp.configs["rust-analyzer"],
		dap = {
			adapter = require("rust-tools.dap").get_codelldb_adapter(M.codelldb, M.liblldb),
		},
	})
end

return M
