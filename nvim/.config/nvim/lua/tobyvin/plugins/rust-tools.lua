local utils = require("tobyvin.utils")
local lsp = require("tobyvin.lsp")
local M = {
	codelldb = "/usr/lib/codelldb/adapter/codelldb",
	liblldb = "/usr/lib/codelldb/lldb/lib/liblldb.so",
}

M.dap_adapter = function()
	if vim.fn.executable(M.codelldb) ~= 0 then
		return {
			adapter = require("rust-tools.dap").get_codelldb_adapter(M.codelldb, M.liblldb),
		}
	end
	vim.notify("Failed to find codelldb adapter")
end

M.cargo_cmd = function()
	utils.run_cmd_with_args("cargo")
end

M.setup = function()
	local status_ok, rust_tools = pcall(require, "rust-tools")
	if not status_ok then
		vim.notify("Failed to load module 'rust-tools'", "error")
		return
	end

	rust_tools.setup({
		server = lsp.config({
			standalone = true,
			settings = {
				["rust-analyzer"] = {
					cargo = {
						allFeatures = true,
					},
					checkOnSave = {
						command = "clippy",
					},
				},
			},
			on_attach = function(client, bufnr)
				if vim.fn.executable(M.codelldb) == 0 then
					vim.notify(
						"[DAP] Failed to find codelldb, falling back to default DAP adapter.",
						"warn",
						{ title = "[rust-tools] codelldb not found" }
					)
				end
				vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
				vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
				vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
				lsp.on_attach(client, bufnr)

				local nmap = utils.create_map_group("n", "<leader>", { buffer = bufnr })
				nmap("dd", rust_tools.debuggables.debuggables, { desc = "Debug" })

				local nmap_run = utils.create_map_group("n", "<leader>r", { desc = "Run", buffer = bufnr })
				nmap_run("r", rust_tools.runnables.runnables, { desc = "Runnables" })
				nmap_run("c", M.cargo_cmd, { desc = "Command" })
				nmap_run("o", rust_tools.open_cargo_toml.open_cargo_toml, { desc = "Open Cargo.toml" })
			end,
		}),
		dap = M.dap_adapter(),
	})
end

return M
