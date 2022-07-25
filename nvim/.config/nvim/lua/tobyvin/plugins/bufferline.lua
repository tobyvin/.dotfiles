local utils = require("tobyvin.utils")
local M = {}

M.diagnostic_signs = function(name)
	name = name:gsub("warning", "warn")
	return utils.diagnostic_signs[name]
end

M.diagnostics_indicator = function(_, _, errors, _)
	local s = " "
	for e, n in pairs(errors) do
		local sign = utils.diagnostic_signs[e:gsub("warning", "warn")].text
		s = s .. (#s > 1 and " " or "") .. sign .. n
	end
	return s
end

M.setup = function()
	local status_ok, bufferline = pcall(require, "bufferline")
	if not status_ok then
		vim.notify("failed to load module 'bufferline'", "error")
		return
	end

	bufferline.setup({
		options = {
			right_mouse_command = "buffer %d",
			always_show_bufferline = false,
			diagnostics = "nvim_lsp",
			diagnostics_indicator = M.diagnostics_indicator,
			-- show_tab_indicators = true,
			show_close_icon = false,
			left_trunc_marker = "<",
			right_trunc_marker = ">",
		},
	})

	local nmap = utils.create_map_group("n", "<leader>b", { desc = "Buffers" })
	nmap("c", bufferline.close_with_pick, { desc = "Close Buffer" })
	nmap("b", bufferline.pick_buffer, { desc = "Pick Buffer" })
end

return M
