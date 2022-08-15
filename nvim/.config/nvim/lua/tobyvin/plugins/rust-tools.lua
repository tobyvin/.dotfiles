local Job = require("plenary.job")
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

M.cargo_subcmd = function(subcmd)
	vim.ui.input({ prompt = string.format("cargo %s", subcmd) }, function(input)
		if input == nil then
			return
		end
		local args = { subcmd }
		for _, arg in ipairs(vim.split(input, " ", { trimempty = true })) do
			table.insert(args, arg)
		end

		local cmd = "cargo"
		local notification
		local output = ""
		local length = 0
		local win, height
		local on_data = function(_, data)
			output = output .. data .. "\n"
			notification = vim.notify(vim.trim(output), vim.log.levels.INFO, {
				title = string.format("[%s] %s", cmd, subcmd),
				replace = notification,
				on_open = function(win_)
					win, height = win_, vim.api.nvim_win_get_height(win_)
				end,
			})
			if height then
				vim.api.nvim_win_set_height(win, height + length)
			end
			length = length + 1
		end

		local job = Job:new({
			command = "cargo",
			args = args,
			on_stdout = vim.schedule_wrap(on_data),
			on_stderr = vim.schedule_wrap(on_data),
		})

		job:start()
	end)
end

M.cargo_add = function()
	M.cargo_subcmd("add")
end

M.cargo_rm = function()
	M.cargo_subcmd("rm")
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

				local nmap_run_cargo = utils.create_map_group("n", "<leader>rc", { desc = "Cargo", buffer = bufnr })
				nmap_run_cargo("o", rust_tools.open_cargo_toml.open_cargo_toml, { desc = "Open Cargo.toml" })
				nmap_run_cargo("a", M.cargo_add, { desc = "Add Crate" })
				nmap_run_cargo("r", M.cargo_rm, { desc = "Remove Crate" })
			end,
		}),
		dap = M.dap_adapter(),
	})
end

return M
