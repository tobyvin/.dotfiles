local utils = require("tobyvin.utils")
local M = {}

M.to_char = function(str)
	return str:sub(1, 1)
end

M.diff_source = function()
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.changed,
			removed = gitsigns.removed,
		}
	end
end

M.theme = function()
	local config = require("gruvbox.config")
	local colors = require("gruvbox.colors").setup(config)

	local theme = {
		normal = {
			a = { bg = colors.info, fg = colors.black },
			b = { bg = colors.bg_highlight, fg = colors.info },
			c = { bg = "none", fg = colors.fg_sidebar, gui = "none" },
		},

		insert = {
			a = { bg = colors.gitSigns.add, fg = colors.black },
			b = { bg = colors.bg_highlight, fg = colors.gitSigns.add },
		},
		command = {
			a = { bg = colors.warning, fg = colors.black },
			b = { bg = colors.bg_highlight, fg = colors.warning },
		},

		visual = {
			a = { bg = colors.warning, fg = colors.black },
			b = { bg = colors.bg_highlight, fg = colors.warning },
		},

		replace = {
			a = { bg = colors.error, fg = colors.black },
			b = { bg = colors.bg_highlight, fg = colors.error },
		},

		inactive = {
			a = { bg = "none", fg = colors.info, gui = "none" },
			b = { bg = "none", fg = colors.comment, gui = "none" },
			c = { bg = "none", fg = colors.comment, gui = "none" },
		},
	}

	return theme
end

M.setup = function()
	local status_ok, lualine = pcall(require, "lualine")
	if not status_ok then
		return
	end

	local navic_ok, navic = pcall(require, "nvim-navic")
	local auto_session_ok, auto_session_library = pcall(require, "auto-session-library")

	local modules = require("lualine_require").lazy_require({
		highlight = "lualine.highlight",
		utils = "lualine.utils.utils",
	})

	local buffer = require("lualine.components.buffers.buffer")
	---returns rendered buffer
	---@return string
	function buffer:render()
		local name = self:name()
		if self.options.fmt then
			name = self.options.fmt(name or "", self.bufnr)
		end

		if self.ellipse then -- show ellipsis
			name = "..."
		else
			name = self:apply_mode(name)
		end
		name = buffer.apply_padding(name, self.options.padding)
		self.len = vim.fn.strchars(name)

		-- setup for mouse clicks
		local line = self:configure_mouse_click(name)
		-- apply highlight
		line = modules.highlight.component_format_highlight(self.highlights[(self.current and "active" or "inactive")])
			.. line

		-- apply separators
		if self.options.self.section < "x" and not self.first then
			local sep_before = self:separator_before()
			line = sep_before .. line
			self.len = self.len + vim.fn.strchars(sep_before)
		elseif self.options.self.section >= "x" and not self.last then
			local sep_after = self:separator_after()
			line = line .. sep_after
			self.len = self.len + vim.fn.strchars(sep_after)
		end
		return line
	end

	local tab = require("lualine.components.tabs.tab")

	---returns name for tab. Tabs name is the name of buffer in last active window
	--- of the tab.
	---@return string
	function tab:label()
		local ok, custom_tabname = pcall(vim.api.nvim_tabpage_get_var, self.tabId, "tabname")
		if not ok then
			custom_tabname = nil
		end
		if custom_tabname and custom_tabname ~= "" then
			return modules.utils.stl_escape(custom_tabname)
		elseif self.options.mode == 1 then
			return tostring(self.tabnr)
		end
		local buflist = vim.fn.tabpagebuflist(self.tabnr)
		local winnr = vim.fn.tabpagewinnr(self.tabnr)
		local bufnr = buflist[winnr]
		local file = modules.utils.stl_escape(vim.api.nvim_buf_get_name(bufnr))
		local buftype = vim.fn.getbufvar(bufnr, "&buftype")
		if buftype == "help" then
			return "help:" .. vim.fn.fnamemodify(file, ":t:r")
		elseif buftype == "terminal" then
			local match = string.match(vim.split(file, " ")[1], "term:.*:(%a+)")
			return match ~= nil and match or vim.fn.fnamemodify(vim.env.SHELL, ":t")
		elseif vim.fn.isdirectory(file) == 1 then
			return vim.fn.fnamemodify(file, ":p:.")
		elseif file == "" then
			return "[No Name]"
		end
		return vim.fn.fnamemodify(file, ":t")
	end

	lualine.setup({
		options = {
			theme = M.theme(),
			refresh = {
				statusline = 200,
			},
			component_separators = "",
			section_separators = "",
		},
		sections = {
			lualine_a = { { "mode", fmt = M.to_char } },
			lualine_b = {
				"branch",
				{ "diff", source = M.diff_source },
				{
					"diagnostics",
					sources = { "nvim_workspace_diagnostic", "nvim_lsp" },
					symbols = {
						error = utils.diagnostic_signs.error.text,
						warn = utils.diagnostic_signs.warn.text,
						info = utils.diagnostic_signs.info.text,
						hint = utils.diagnostic_signs.hint.text,
					},
				},
			},
			lualine_c = {
				{
					auto_session_library.current_session_name,
					cond = function()
						return auto_session_ok
					end,
					separator = ">",
				},
				{
					"filename",
					path = 1,
					separator = ">",
					shorting_target = 100,
				},
				{
					navic.get_location,
					cond = function()
						return navic_ok and navic.is_available()
					end,
				},
			},
			lualine_x = {
				"encoding",
				"fileformat",
				"filetype",
			},
		},
		tabline = {
			lualine_b = {
				{
					"buffers",
					fmt = function(name, bufnr)
						return string.format("%s %s", name, utils.diagnostic_indicator(bufnr))
					end,
				},
			},
			lualine_y = { { "tabs", mode = 1 } },
		},
		extensions = { "quickfix", "man", "fzf", "nvim-dap-ui", "symbols-outline", "toggleterm" },
	})
end

return M
