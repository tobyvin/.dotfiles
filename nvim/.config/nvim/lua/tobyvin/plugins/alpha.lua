---@diagnostic disable: missing-parameter
local Icons = require("nvim-web-devicons")
local utils = require("tobyvin.utils")
local M = {
	position = "center",
	width = 60,
}

--- @param str string
--- @param position '"left"' | '"right"' | '"center"'
M.format_string = function(str, position)
	local fmt
	if position == "right" then
		fmt = "%+" .. M.width .. "s"
	elseif position == "center" then
		fmt = "%+" .. math.ceil(M.width / 2) .. "s"
	else
		fmt = "%-" .. M.width .. "s"
	end
	return string.format(fmt, str)
end

--- @param sc string
--- @param txt string
--- @param keybind string? optional
--- @param keybind_opts table? optional
M.button = function(sc, txt, keybind, keybind_opts)
	local sc_ = sc:gsub("%s", "")

	local opts = {
		position = M.position,
		shortcut = "[" .. sc .. "] ",
		cursor = M.width - 3,
		width = M.width,
		align_shortcut = "right",
		hl_shortcut = { { "Special", 0, 1 }, { "Number", 1, #sc + 1 }, { "Special", #sc + 1, #sc + 2 } },
		shrink_margin = false,
	}

	if keybind then
		keybind_opts = vim.F.if_nil(keybind_opts, {})
		keybind_opts.desc = vim.F.if_nil(keybind_opts.desc, txt)
		opts.keymap = { "n", sc_, keybind, keybind_opts }
	end

	local function on_press()
		local key = vim.api.nvim_replace_termcodes(keybind .. "<Ignore>", true, false, true)
		---@diagnostic disable-next-line: param-type-mismatch
		vim.api.nvim_feedkeys(key, "t", false)
	end

	return {
		type = "button",
		val = txt,
		on_press = on_press,
		opts = opts,
	}
end

M.file_button = function(filename, sc)
	local short_fn = utils.fs.shorten_path(filename, M.width)
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
	local button = M.button(sc, ico_txt .. short_fn, "<Cmd>e " .. filename .. " <CR>", { desc = "oldfile_" .. sc })
	button.opts.hl = hl
	button.opts.cursor = M.width - 1
	return button
end

M.mru_filter = function(filename)
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

M.mru_cache = nil
M.mru = function()
	if M.mru_cache == nil then
		local oldfiles = { unpack(vim.tbl_filter(M.mru_filter, vim.v.oldfiles), 1, 10) }
		local tbl = {}
		for i, filename in ipairs(oldfiles) do
			tbl[i] = M.file_button(filename, tostring(i % 10))
		end
		M.mru_cache = { {
			type = "group",
			val = tbl,
		} }
	end
	return M.mru_cache
end

M.actions_cache = nil
M.actions = function()
	if M.actions_cache == nil then
		local builtins = require("telescope.builtin")
		local neogit = require("neogit")
		M.actions_cache = {
			{
				type = "group",
				val = {
					M.button("e", "new", "<cmd>enew<cr>"),
					M.button("f", "find", builtins.find_files),
					M.button("g", "git", neogit.open),
					M.button("s", "session", "<cmd>SessionManager load_current_dir_session<cr>"),
					M.button("q", "quit", "<cmd>qa<cr>"),
				},
			},
		}
	end
	return M.actions_cache
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

local logo = {
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
		position = M.position,
		hl = "DevIconVim",
	},
}

local function info_value()
	local total_plugins = #vim.tbl_keys(packer_plugins)
	local v = vim.F.if_nil(vim.version(), {})
	return string.format("VIM: v%d.%d.%d PLUGINS: %d", v.major, v.minor, v.patch, total_plugins)
end

local info = {
	type = "text",
	val = info_value(),
	opts = {
		hl = "DevIconVim",
		position = M.position,
	},
}

local message = {
	type = "text",
	val = fortune({ max_width = M.width }),
	opts = {
		position = M.position,
		hl = "Statement",
	},
}

local header = {
	type = "group",
	val = {
		logo,
		info,
		message,
	},
}

local mru = {
	type = "group",
	val = {
		{
			type = "text",
			val = M.format_string("MRU"),
			opts = {
				hl = "String",
				position = M.position,
			},
		},
		{
			type = "group",
			val = M.mru,
		},
	},
}

local actions = {
	type = "group",
	val = {
		{
			type = "text",
			val = M.format_string("CMD"),
			opts = {
				hl = "String",
				position = M.position,
			},
		},
		{
			type = "group",
			val = M.actions,
		},
	},
}

local config = {
	layout = {
		header,
		{ type = "padding", val = 1 },
		mru,
		{ type = "padding", val = 1 },
		actions,
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

return M
