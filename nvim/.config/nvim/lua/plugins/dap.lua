---@type LazyPluginSpec
local M = {
	"mfussenegger/nvim-dap",
	cmd = {
		"Break",
		"DapShowLog",
		"DapContinue",
		"DapToggleBreakpoint",
		"DapLoadLaunchJSON",
	},
	keys = {
		"<leader>db",
		"<leader>dl",
		"<F5>",
	},
	dependencies = {
		"mfussenegger/nvim-dap-python",
		"leoluz/nvim-dap-go",
		"nvim-telescope/telescope-dap.nvim",
		{
			"theHamsta/nvim-dap-virtual-text",
			dependencies = { "nvim-treesitter/nvim-treesitter" },
			opts = {
				commented = true,
			},
		},
	},
}

function M:config()
	require("dap").listeners.after.event_initialized["User"] = function()
		vim.api.nvim_exec_autocmds("User", { pattern = "DapAttach" })
		vim.notify("DAP attached", vim.log.levels.INFO)
	end

	require("dap").listeners.before.event_terminated["User"] = function()
		vim.api.nvim_exec_autocmds("User", { pattern = "DapDetach" })
		require("dap").repl.close()
		vim.notify("DAP detached", vim.log.levels.INFO)
	end

	local adapters = require("tobyvin.dap.adapters")
	for name, adapter in pairs(adapters) do
		if require("dap").adapters[name] == nil then
			require("dap").adapters[name] = adapter
		end
	end

	local configs = require("tobyvin.dap.configs")
	for name, config in pairs(configs) do
		if require("dap").configurations[name] == nil then
			require("dap").configurations[name] = config
		end
	end

	vim.fn.sign_define("DapBreakpoint", { text = "󰝥 ", texthl = "debugBreakpoint" })
	vim.fn.sign_define("DapBreakpointCondition", { text = "󰟃 ", texthl = "debugBreakpoint" })
	vim.fn.sign_define("DapBreakpointRejected", { text = " ", texthl = "debugBreakpoint", numhl = "Error" })
	vim.fn.sign_define("DapLogPoint", { text = " ", texthl = "debugBreakpoint" })
	vim.fn.sign_define("DapStopped", { text = " ", texthl = "debugBreakpoint", linehl = "CursorLine" })

	vim.keymap.set("n", "<F5>", require("dap").continue, { desc = "continue" })
	vim.keymap.set("n", "<F10>", require("dap").step_over, { desc = "step over" })
	vim.keymap.set("n", "<F11>", require("dap").step_into, { desc = "step into" })
	vim.keymap.set("n", "<F12>", require("dap").step_out, { desc = "step out" })
	vim.keymap.set("n", "<leader>dq", require("dap").terminate, { desc = "terminate" })
	vim.keymap.set("n", "<leader>db", require("dap").toggle_breakpoint, { desc = "toggle breakpoint" })
	vim.keymap.set("n", "<leader>dl", require("dap.ui.widgets").hover)

	vim.api.nvim_create_user_command("Break", function(opts)
		require("dap").toggle_breakpoint(unpack(opts.fargs))
	end, { nargs = "*", desc = "toggle breakpoint" })
end

return M
