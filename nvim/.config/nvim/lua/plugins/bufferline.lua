local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
	return
end

-- https://github.com/Mofiqul/vscode.nvim#-usage

local diagnostics_signs = {
  ['error'] = '',
  warning = '',
  default = '',
}

require('bufferline').setup{
  options = {
		indicator_icon = ' ',
    buffer_close_icon = '',
    modified_icon = '●',
    close_icon = '',
		close_command = "Bdelete! %d",
		right_mouse_command = "Bdelete! %d",
    always_show_bufferline = false,
    diagnostics = 'nvim_lsp',
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local s = ' '
      for e, n in pairs(diagnostics_dict) do
        local sym = diagnostics_signs[e] or diagnostics_signs.default
        s = s .. (#s > 1 and ' ' or '') .. sym .. ' ' .. n
      end
      return s
    end,
    -- separator_style = 'slant',
		offsets = {{filetype = "NvimTree", text = "EXPLORER", text_align = "center"}},
		show_tab_indicators = true,
		show_close_icon = false
  },
	highlights = {
		fill = {
			guifg = {attribute = "fg", highlight = "Normal"},
			guibg = {attribute = "bg", highlight = "StatusLineNC"},
		},
		background = {
			guifg = {attribute = "fg", highlight = "Normal"},
			guibg = {attribute = "bg", highlight = "StatusLine"}
		},
		buffer_visible = {
			gui = "",
      guifg = {attribute = "fg", highlight="Normal"},
      guibg = {attribute = "bg", highlight = "Normal"}
		},
		buffer_selected = {
			gui = "",
      guifg = {attribute = "fg", highlight="Normal"},
      guibg = {attribute = "bg", highlight = "Normal"}
		},
		separator = {
			guifg = {attribute = "bg", highlight = "Normal"},
			guibg = {attribute = "bg", highlight = "StatusLine"},
		},
		separator_selected = {
      guifg = {attribute = "fg", highlight="Special"},
      guibg = {attribute = "bg", highlight = "Normal"}
		},
		separator_visible = {
			guifg = {attribute = "fg", highlight = "Normal"},
			guibg = {attribute = "bg", highlight = "StatusLineNC"},
		},
		close_button = {
			guifg = {attribute = "fg", highlight = "Normal"},
			guibg = {attribute = "bg", highlight = "StatusLine"}
		},
		close_button_selected = {
      guifg = {attribute = "fg", highlight="normal"},
      guibg = {attribute = "bg", highlight = "normal"}
		},
		close_button_visible = {
      guifg = {attribute = "fg", highlight="normal"},
      guibg = {attribute = "bg", highlight = "normal"}
		},

	}
}
