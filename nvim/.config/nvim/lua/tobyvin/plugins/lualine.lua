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

M.setup = function()
	local status_ok, lualine = pcall(require, "lualine")
	if not status_ok then
		return
	end

	local nvim_navic = require("nvim-navic")

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
				{ "filetype", icon_only = true, colored = false },
				"filename",
				{ nvim_navic.get_location, cond = nvim_navic.is_available },
			},
			lualine_x = {
				"encoding",
				"fileformat",
				"filetype",
			},
		},
		tabline = {
			-- lualine_b = { { "buffers", buffers_color = { inactive = "StatusLineNC" } } },
			lualine_b = {
				{
					"buffers",
					-- TODO: figure out how to highlight diagnostic signs
					fmt = function(name, bufnr)
						return string.format("%s %s", name, utils.diagnostics_str(bufnr))
					end,
				},
			},
			-- lualine_y = { "tabs" },
			lualine_y = { { "tabs", mode = 1 } },
		},
		extensions = { "quickfix", "man", "fzf", "nvim-dap-ui" },
	})

	-- local nmap = utils.create_map_group("n", "<leader>b", { desc = "Buffers" })
	-- nmap("c", M.close_with_pick, { desc = "Close Buffer" })
	-- nmap("b", M.pick_buffer, { desc = "Pick Buffer" })
end

return M
