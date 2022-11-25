local utils = require("tobyvin.utils")
local M = {
	configs = require("tobyvin.plugins.dap.configs"),
	adapters = require("tobyvin.plugins.dap.adapters"),
	events = require("tobyvin.plugins.dap.events"),
	hover = require("tobyvin.plugins.dap.hover"),
}

local set_custom_breakpoint = function()
	vim.ui.input({ prompt = "Condition: " }, function(condition)
		vim.ui.input({ prompt = "Hit condition: " }, function(hit_condition)
			vim.ui.input({ prompt = "Log point message: " }, function(log_message)
				require("dap").set_breakpoint(condition, hit_condition, log_message)
			end)
		end)
	end)
end

---@param config table
---@return function
local with_eval = function(config)
	return function()
		local evaluated = {}
		for key, value in pairs(config) do
			if type(value) == "function" then
				evaluated[key] = value()
			end
		end
		return vim.tbl_extend("keep", evaluated, config)
	end
end

---@param config table
---@return boolean
local contains_func = function(config)
	for _, value in pairs(config) do
		if type(value) == "function" then
			return true
		end
	end
	return false
end

---@param config table
---@return table|function
local make_config = function(config)
	if contains_func(config) then
		return with_eval(config)
	end
	return config
end

M.setup = function()
	local status_ok, dap = pcall(require, "dap")
	if not status_ok then
		vim.notify("Failed to load module 'dap'", vim.log.levels.ERROR)
		return
	end

	dap.defaults.fallback.focus_terminal = true
	dap.defaults.fallback.terminal_win_cmd = "15split new"

	M.events.setup()
	M.hover.setup()

	for name, config in pairs(M.configs) do
		if dap.configurations[name] == nil then
			dap.configurations[name] = make_config(config)
		end
	end

	require("dap-python").setup()
	require("dap-go").setup()

	require("nvim-dap-virtual-text").setup({
		-- only_first_definition = false,
		-- all_references = true,
		virt_text_pos = "right_align",
	})

	require("telescope").load_extension("dap")
	local telescope = require("telescope").extensions.dap

	vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "toggle breakpoint" })
	vim.keymap.set("n", "<leader>dB", set_custom_breakpoint, { desc = "custom breakpoint" })
	vim.keymap.set("n", "<leader>dC", telescope.commands, { desc = "commands" })
	vim.keymap.set("n", "<leader>dd", telescope.configurations, { desc = "configurations" })
	vim.keymap.set("n", "<leader>dl", telescope.list_breakpoints, { desc = "list breakpoints" })

	vim.api.nvim_create_autocmd("User", {
		pattern = "DapAttach",
		callback = function()
			vim.keymap.set("n", "<F5>", dap.continue, { desc = "continue" })
			vim.keymap.set("n", "<F10>", dap.step_over, { desc = "step over" })
			vim.keymap.set("n", "<F11>", dap.step_into, { desc = "step into" })
			vim.keymap.set("n", "<F12>", dap.step_out, { desc = "step out" })
			vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "continue" })
			vim.keymap.set("n", "<leader>da", dap.step_over, { desc = "step over" })
			vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "step into" })
			vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "step out" })
			vim.keymap.set("n", "<leader>dq", dap.terminate, { desc = "terminate" })
			vim.keymap.set("n", "<leader>dv", telescope.variables, { desc = "variables" })
			vim.keymap.set("n", "<leader>df", telescope.frames, { desc = "frames" })
		end,
	})

	vim.api.nvim_create_autocmd("User", {
		pattern = "DapDetach",
		callback = function()
			vim.keymap.del("n", "<leader>dv")
			vim.keymap.del("n", "<leader>df")
			vim.keymap.del("n", "<leader>dc")
			vim.keymap.del("n", "<leader>da")
			vim.keymap.del("n", "<leader>di")
			vim.keymap.del("n", "<leader>do")
			vim.keymap.del("n", "<leader>dq")
			vim.keymap.del("n", "<F5>")
			vim.keymap.del("n", "<F10>")
			vim.keymap.del("n", "<F11>")
			vim.keymap.del("n", "<F12>")
		end,
	})

	vim.fn.sign_define("DapBreakpoint", utils.debug.signs.breakpoint)
	vim.fn.sign_define("DapBreakpointCondition", utils.debug.signs.condition)
	vim.fn.sign_define("DapBreakpointRejected", utils.debug.signs.rejected)
	vim.fn.sign_define("DapStopped", utils.debug.signs.stopped)
	vim.fn.sign_define("DapLogPoint", utils.debug.signs.logpoint)
end

return M
