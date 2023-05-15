local M = {
	"mfussenegger/nvim-dap",
	dependencies = {
		{
			"nvim-telescope/telescope-dap.nvim",
			dependencies = {
				"nvim-telescope/telescope.nvim",
			},
			init = function()
				vim.keymap.set("n", "<leader>dC", function()
					require("telescope").extensions.dap.commands()
				end, { desc = "commands" })

				vim.keymap.set("n", "<leader>dd", function()
					require("telescope").extensions.dap.configurations()
				end, { desc = "configurations" })

				vim.keymap.set("n", "<leader>dl", function()
					require("telescope").extensions.dap.list_breakpoints()
				end, { desc = "breakpoints" })

				vim.keymap.set("n", "<leader>df", function()
					require("telescope").extensions.dap.frames()
				end, { desc = "frames" })

				vim.keymap.set("n", "<leader>dv", function()
					require("telescope").extensions.dap.variables()
				end, { desc = "variables" })
			end,
			config = function()
				require("telescope").load_extension("dap")
			end,
		},
		{
			"rcarriga/cmp-dap",
			ft = { "dap-repl" },
			dependencies = {
				"hrsh7th/nvim-cmp",
			},
			config = function()
				require("cmp").setup.filetype({ "dap-repl" }, {
					sources = {
						{ name = "dap" },
					},
				})
			end,
		},
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

	vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "debugBreakpoint" })
	vim.fn.sign_define("DapBreakpointCondition", { text = "ﳁ ", texthl = "debugBreakpoint" })
	vim.fn.sign_define("DapBreakpointRejected", { text = " ", texthl = "debugBreakpoint" })
	vim.fn.sign_define("DapLogPoint", { text = " ", texthl = "debugBreakpoint" })
	vim.fn.sign_define("DapStopped", { text = " ", texthl = "debugBreakpoint" })
end

return M
