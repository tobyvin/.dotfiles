local M = {
	"mfussenegger/nvim-dap",
	dependencies = {
		"nvim-telescope/telescope-dap.nvim",
		"rcarriga/cmp-dap",
		"mfussenegger/nvim-dap-python",
		"leoluz/nvim-dap-go",
		{
			"theHamsta/nvim-dap-virtual-text",
			dependencies = { "nvim-treesitter/nvim-treesitter" },
			opts = {
				commented = true,
				display_callback = function(variable)
					return " " .. variable.value
				end,
			},
			config = true,
		},
	},
}

function M.init()
	local dap = setmetatable({}, {
		__index = function(_, k)
			return function()
				require("dap")[k]()
			end
		end,
	})

	vim.keymap.set("n", "<F5>", dap.continue, { desc = "continue" })
	vim.keymap.set("n", "<F10>", dap.step_over, { desc = "step over" })
	vim.keymap.set("n", "<F11>", dap.step_into, { desc = "step into" })
	vim.keymap.set("n", "<F12>", dap.step_out, { desc = "step out" })
	vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "continue" })
	vim.keymap.set("n", "<leader>da", dap.step_over, { desc = "step over" })
	vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "step into" })
	vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "step out" })
	vim.keymap.set("n", "<leader>dq", dap.terminate, { desc = "terminate" })
	vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "toggle breakpoint" })

	vim.keymap.set("n", "<leader>dB", function()
		vim.ui.input({ prompt = "Condition: " }, function(cond)
			vim.ui.input({ prompt = "Hit condition: " }, function(hit)
				vim.ui.input({ prompt = "Log point message: " }, function(msg)
					require("dap").set_breakpoint(cond, hit, msg)
				end)
			end)
		end)
	end, { desc = "custom breakpoint" })
end

function M.config()
	require("dap").listeners.after.event_initialized["User"] = function()
		vim.api.nvim_exec_autocmds("User", { pattern = "DapAttach" })
	end

	require("dap").listeners.before.event_terminated["User"] = function()
		vim.api.nvim_exec_autocmds("User", { pattern = "DapDetach" })
		require("dap").repl.close()
	end

	local adapters = require("tobyvin.plugins.dap.adapters")
	for name, adapter in pairs(adapters) do
		if require("dap").adapters[name] == nil then
			require("dap").adapters[name] = adapter
		end
	end

	local configs = require("tobyvin.plugins.dap.configs")
	for name, config in pairs(configs) do
		if require("dap").configurations[name] == nil then
			require("dap").configurations[name] = config
		end
	end

	local signs = require("tobyvin.utils.debug").signs
	vim.fn.sign_define("DapBreakpoint", signs.breakpoint)
	vim.fn.sign_define("DapBreakpointCondition", signs.condition)
	vim.fn.sign_define("DapBreakpointRejected", signs.rejected)
	vim.fn.sign_define("DapStopped", signs.stopped)
	vim.fn.sign_define("DapLogPoint", signs.logpoint)
end

return M
