local Icons = require("nvim-web-devicons")
local utils = require("tobyvin.utils")

local file_button = function(filename, sc)
	local short_fn = utils.fs.shorten_path(filename, 60)
	local hl = {}

	local filetype, _ = vim.filetype.match({ filename = filename })
	filetype = vim.F.if_nil(filetype, "")
	local ico, ico_hl = Icons.get_icon_by_filetype(filetype, { default = true })
	table.insert(hl, { ico_hl, 0, 3 })
	local ico_txt = ico .. "  "
	local fn_start = short_fn:match(".*[/\\]")
	if fn_start ~= nil then
		table.insert(hl, { "Comment", #ico_txt - 2, #fn_start + #ico_txt })
	end

	local keybind = "<Cmd>e " .. filename .. " <CR>"
	local button = {
		type = "button",
		val = ico_txt .. short_fn,
		on_press = function()
			local key = vim.api.nvim_replace_termcodes(keybind .. "<Ignore>", true, false, true)
			vim.api.nvim_feedkeys(key, "t", false)
		end,
		opts = {
			position = "center",
			shortcut = "[" .. sc .. "]",
			cursor = 60,
			width = 60,
			align_shortcut = "right",
			hl = hl,
			hl_shortcut = { { "Special", 0, 1 }, { "Number", 1, #sc + 1 }, { "Special", #sc + 1, #sc + 2 } },
			shrink_margin = false,
			keymap = { "n", sc:gsub("%s", ""), keybind, { desc = "oldfile_" .. sc } },
		},
	}
	return button
end

local mru_filter = function(filename)
	local ignored_ft = { "gitcommit" }
	local cwd = vim.fn.getcwd()
	local filetype, _ = vim.filetype.match({ filename = filename })
	filetype = vim.F.if_nil(filetype, "")
	local ignored = false
	for _, pattern in pairs(ignored_ft) do
		ignored = ignored or filetype:match(pattern) ~= nil
	end
	return not ignored and (vim.fn.filereadable(filename) == 1) and vim.startswith(filename, cwd)
end

local mru_cache = nil
local get_mru = function()
	if mru_cache == nil then
		local oldfiles = { unpack(vim.tbl_filter(mru_filter, vim.v.oldfiles), 1, 20) }
		local tbl = {}
		for i, filename in ipairs(oldfiles) do
			tbl[i] = file_button(filename, tostring(i % 10))
		end
		mru_cache = { {
			type = "group",
			val = tbl,
		} }
	end
	return mru_cache
end

local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
	vim.notify("Failed to load module 'alpha'", vim.log.levels.ERROR)
	return
end

alpha.keymaps_element.button = function(el, _, state)
	if el.opts and el.opts.keymap then
		if type(el.opts.keymap[1]) == "table" then
			for _, map in el.opts.keymap do
				map[4].buffer = state.buffer
				vim.keymap.set(unpack(map))
			end
		else
			local map = el.opts.keymap
			map[4].buffer = state.buffer
			vim.keymap.set(unpack(map))
		end
	end
end

local fortune = require("alpha.fortune")

local function info_value()
	local total_plugins = #vim.tbl_keys(packer_plugins)
	local v = vim.F.if_nil(vim.version(), {})
	return string.format("VIM: v%d.%d.%d PLUGINS: %d", v.major, v.minor, v.patch, total_plugins)
end

local config = {
	layout = {
		{
			type = "text",
			val = {
				"                                                    ",
				" ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
				" ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
				" ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
				" ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
				" ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
				" ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
			},
			opts = {
				position = "center",
				hl = "DevIconVim",
			},
		},
		{
			type = "text",
			val = info_value(),
			opts = {
				hl = "DevIconVim",
				position = "center",
			},
		},
		{
			type = "text",
			val = fortune({ max_width = 60 }),
			opts = {
				position = "center",
				hl = "Statement",
			},
		},
		{ type = "padding", val = 1 },
		{
			type = "group",
			val = get_mru,
		},
	},
}

alpha.setup(config)

vim.api.nvim_create_autocmd("User", {
	group = vim.api.nvim_create_augroup("alpha_user", { clear = true }),
	pattern = "BDeleteLast",
	callback = function(args)
		local bufnr = vim.F.if_nil(args.data.buf, args.buf)
		if vim.api.nvim_buf_get_option(bufnr, "filetype") ~= "alpha" then
			alpha.start(false)
		end
	end,
	desc = "Run Alpha when last buffer closed",
})
