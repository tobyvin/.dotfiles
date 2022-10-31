local utils = require("tobyvin.utils")
local lsp = require("tobyvin.lsp")
local M = {
	codelldb = "/usr/lib/codelldb/adapter/codelldb",
	liblldb = "/usr/lib/codelldb/lldb/lib/liblldb.so",
	popup_id = "",
}

M.setup = function()
	local status_ok, rust_tools = pcall(require, "rust-tools")
	if not status_ok then
		vim.notify("Failed to load module 'rust-tools'", vim.log.levels.ERROR)
		return
	end

	local function parse_lines(t)
		local ret = {}

		local name = t.name
		local text = "// Recursive expansion of the " .. name .. " macro"
		table.insert(ret, "// " .. string.rep("=", string.len(text) - 3))
		table.insert(ret, text)
		table.insert(ret, "// " .. string.rep("=", string.len(text) - 3))
		table.insert(ret, "")

		local expansion = t.expansion
		for string in string.gmatch(expansion, "([^\n]+)") do
			table.insert(ret, string)
		end

		return ret
	end

	local handler = function(_, result)
		if result == nil then
			vim.api.nvim_out_write("No macro under cursor!\n")
			return
		end

		local contents = parse_lines(result)
		local opts = {
			focus_id = "expand_macro",
			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
			border = "single",
			scope = "cursor",
		}
		vim.lsp.util.open_floating_preview(contents, "rust", opts)
	end

	require("rust-tools.expand_macro").expand_macro = function()
		---@diagnostic disable-next-line: missing-parameter
		local params = vim.lsp.util.make_position_params()
		rust_tools.utils.request(0, "rust-analyzer/expandMacro", params, handler)
	end

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("tobyvin_rust-tools", { clear = true }),
		desc = "setup rust-tools",
		callback = function(args)
			local bufnr = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if client.name ~= "rust_analyzer" then
				return
			end

			local runnables = rust_tools.runnables.runnables
			local debuggables = rust_tools.debuggables.debuggables
			local open_cargo_toml = rust_tools.open_cargo_toml.open_cargo_toml
			local external_docs = rust_tools.external_docs.open_external_docs
			local expand_macro = rust_tools.expand_macro.expand_macro
			local hover_actions = rust_tools.hover_actions.hover_actions

			vim.keymap.set("n", "<leader>dd", debuggables, { desc = "Debuggables", buffer = bufnr })
			vim.keymap.set("n", "<leader>r", runnables, { desc = "Runnables", buffer = bufnr })
			vim.keymap.set("n", "<leader>lo", open_cargo_toml, { desc = "Open Cargo.toml", buffer = bufnr })
			vim.keymap.set("n", "<leader>le", expand_macro, { desc = "Expand macro", buffer = bufnr })

			utils.documentation.register("rust", external_docs)
			utils.hover.register(hover_actions, { desc = "rust-tools hover actions", buffer = bufnr, priority = 10 })
		end,
	})

	rust_tools.setup({
		tools = {
			hover_actions = {
				border = "single",
			},
		},
		server = lsp.configs["rust-analyzer"],
		dap = {
			adapter = require("rust-tools.dap").get_codelldb_adapter(M.codelldb, M.liblldb),
		},
	})
end

return M
