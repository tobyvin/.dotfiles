---@diagnostic disable: assign-type-mismatch
local utils = require("tobyvin.utils")
local M = {}

M.diagnostics_indicator = function(_, _, errors, _)
	local outstr = " "
	for level, count in pairs(errors) do
		local sign = utils.diagnostic.signs[level:gsub("warning", "warn")].text
		-- outstr = outstr .. sign .. (#count > 1 and count or "")
		outstr = outstr .. sign .. count
	end
	return outstr
end

M.setup = function()
	local status_ok, bufferline = pcall(require, "bufferline")
	if not status_ok then
		vim.notify("failed to load module 'bufferline'", vim.log.levels.ERROR)
		return
	end

	bufferline.setup({
		-- highlights = {
		-- 	fill = {
		-- 		guibg = {
		-- 			attribute = "fg",
		-- 			highlight = "Pmenu",
		-- 		},
		-- 	},
		-- },
		options = {
			right_mouse_command = "buffer %d",
			always_show_bufferline = false,
			color_icons = false,
			show_close_icon = false,
			show_buffer_close_icons = false,
			diagnostics = "nvim_lsp",
			diagnostics_indicator = M.diagnostics_indicator,
			left_trunc_marker = "<",
			right_trunc_marker = ">",
		},
	})

	local nmap = utils.keymap.group("n", "<leader>b", { desc = "Buffers" })
	nmap("c", bufferline.close_with_pick, { desc = "Close Buffer" })
	nmap("b", bufferline.pick_buffer, { desc = "Pick Buffer" })
end

return M
