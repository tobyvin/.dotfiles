local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
	return
end

local diagnostics_signs = {
	["error"] = "",
	warning = "",
	default = "",
}

require("bufferline").setup({
	options = {
		indicator_icon = " ",
		buffer_close_icon = "",
		modified_icon = "●",
		close_icon = "",
		close_command = "Bdelete! %d",
		right_mouse_command = "Bdelete! %d",
		always_show_bufferline = false,
		diagnostics = "nvim_lsp",
		diagnostics_indicator = function(count, level, diagnostics_dict, context)
			local s = " "
			for e, n in pairs(diagnostics_dict) do
				local sym = diagnostics_signs[e] or diagnostics_signs.default
				s = s .. (#s > 1 and " " or "") .. sym .. " " .. n
			end
			return s
		end,
		show_tab_indicators = true,
		show_close_icon = false,
	},
})
