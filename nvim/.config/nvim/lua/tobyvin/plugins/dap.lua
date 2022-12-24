local M = {
	"mfussenegger/nvim-dap",
	dependencies = {
		"nvim-telescope/telescope-dap.nvim",
		"rcarriga/cmp-dap",
		{
			"mfussenegger/nvim-dap-python",
			config = "",
		},
		{
			"leoluz/nvim-dap-go",
			config = true,
		},
		{
			"theHamsta/nvim-dap-virtual-text",
			dependencies = { "nvim-treesitter/nvim-treesitter" },
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
	local dap = require("dap")
	local utils = require("tobyvin.utils")

	dap.defaults.fallback.focus_terminal = true
	dap.defaults.fallback.terminal_win_cmd = "15split new"

	require("tobyvin.plugins.dap.events").setup()
	require("tobyvin.plugins.dap.hover").setup()

	local configs = require("tobyvin.plugins.dap.configs")
	for name, config in pairs(configs) do
		if dap.configurations[name] == nil then
			dap.configurations[name] = config
		end
	end

	vim.fn.sign_define("DapBreakpoint", utils.debug.signs.breakpoint)
	vim.fn.sign_define("DapBreakpointCondition", utils.debug.signs.condition)
	vim.fn.sign_define("DapBreakpointRejected", utils.debug.signs.rejected)
	vim.fn.sign_define("DapStopped", utils.debug.signs.stopped)
	vim.fn.sign_define("DapLogPoint", utils.debug.signs.logpoint)
end

return M
