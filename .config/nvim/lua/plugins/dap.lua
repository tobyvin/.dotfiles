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
				virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",
			},
		},
	},
}

function M:init()
	local function parse(args)
		local parts = vim.split(vim.trim(args), "%s+")
		if parts[1]:match("Dap") then
			table.remove(parts, 1)
		end
		if args:sub(-1) == " " then
			parts[#parts + 1] = ""
		end
		return table.remove(parts, 1) or "", parts
	end

	vim.api.nvim_create_user_command("Dap", function(cmd)
		local prefix, args = parse(cmd.args)
		local command = require("dap")[prefix]

		if type(command) == "table" then
			command = command[table.remove(args, 1)]
		end

		if type(command) == "function" then
			command(unpack(args))
		else
			vim.notify("Invalid Dap command '" .. prefix .. "'", vim.log.levels.ERROR)
		end
	end, {
		bar = true,
		bang = false,
		nargs = "?",
		desc = "Dap",
		complete = function(_, line)
			local prefix, args = parse(line)
			local cmds = require("dap")

			if #args > 0 then
				if type(require("dap")[prefix]) == "table" then
					cmds = require("dap")[prefix]
					if #cmds == 0 and pcall(require, "dap." .. prefix) then
						cmds = require("dap." .. prefix)
					end
					prefix = args[#args]
				else
					return nil
				end
			end

			---@param key string
			return vim.tbl_filter(function(key)
				return key:find(prefix, 1, true) == 1 and (type(cmds[key]) == "function" or type(cmds[key]) == "table")
			end, vim.tbl_keys(cmds))
		end,
	})
end

function M:config()
	require("dap").listeners.after.event_initialized["User"] = function()
		vim.api.nvim_exec_autocmds("User", { pattern = "DapAttach" })

		for ns in pairs(vim.diagnostic.get_namespaces()) do
			vim.diagnostic.hide(ns)
		end

		vim.notify("DAP attached", vim.log.levels.INFO)
	end

	require("dap").listeners.before.event_terminated["User"] = function()
		vim.api.nvim_exec_autocmds("User", { pattern = "DapDetach" })

		require("dap").repl.close()

		for ns in pairs(vim.diagnostic.get_namespaces()) do
			vim.diagnostic.show(ns)
		end

		vim.notify("DAP detached", vim.log.levels.INFO)
	end

	local adapters = require("tobyvin.dap.adapters")
	for name, adapter in pairs(adapters) do
		if require("dap").adapters[name] == nil then
			require("dap").adapters[name] = adapter
		end
	end

	local configs = require("tobyvin.dap.configs")
	for ft, config in pairs(configs) do
		if require("dap").configurations[ft] == nil then
			require("dap").configurations[ft] = config
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
	vim.keymap.set("n", "<leader>dd", require("dap").continue, { desc = "launch" })

	vim.api.nvim_create_user_command("Break", function(opts)
		require("dap").toggle_breakpoint(unpack(opts.fargs))
	end, { nargs = "*", desc = "toggle breakpoint" })
end

return M
