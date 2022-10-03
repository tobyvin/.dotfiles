---@diagnostic disable: missing-parameter
local filetype = require("plenary.filetype")
local path = require("plenary.path")
local M = {}

M.button = function(...)
	local startify = require("alpha.themes.startify")
	local button = startify.button(...)
	button.opts.position = "center"
	button.opts.width = 60
	button.opts.align_shortcut = "left"
	return button
end

M.get_extension = function(fn)
	local match = fn:match("^.+(%..+)$")
	local ext = ""
	if match ~= nil then
		ext = match:sub(2)
	end
	return ext
end

M.icon = function(fn)
	local nwd_ok, nwd = pcall(require, "nvim-web-devicons")
	local ft = filetype.detect(fn)
	if nwd_ok and ft ~= nil then
		return nwd.get_icon_by_filetype(ft, { default = true })
	else
		return "", ""
	end
end

M.notified = false
M.file_button = function(fn, sc)
	local short_fn = vim.fn.fnamemodify(fn, ":.")
	if vim.fn.strlen(short_fn) > 50 then
		local path_fn = path:new(short_fn)
		local v = -1
		local exclude = { 1, v }
		while v > -20 and vim.fn.strlen(path_fn:shorten(1, exclude)) < 50 do
			v = v - 1
			table.insert(exclude, v)
		end
		short_fn = path_fn:shorten(1, exclude)
	end
	local fb_hl = {}
	local ico, hl = M.icon(fn)
	table.insert(fb_hl, { hl, 0, 1 })
	local ico_txt = ico .. "  "
	local file_button_el = M.button(sc, ico_txt .. short_fn, "<Cmd>e " .. fn .. " <CR>")
	local fn_start = short_fn:match(".*[/\\]")
	if fn_start ~= nil then
		table.insert(fb_hl, { "Comment", #ico_txt - 2, #fn_start + #ico_txt - 2 })
	end
	file_button_el.opts.hl = fb_hl

	file_button_el.opts.position = "center"
	file_button_el.opts.width = 60
	file_button_el.opts.align_shortcut = "left"
	return file_button_el
end

M.mru_filter = function(v)
	local ignored_ft = { "Git.*" }
	local cwd = vim.fn.getcwd()
	local ft = vim.F.if_nil(vim.filetype.match({ filename = v }), "")
	local ignored = false
	for _, pattern in pairs(ignored_ft) do
		ignored = ignored or ft:match(pattern) ~= nil
	end
	return not ignored and (vim.fn.filereadable(v) == 1) and vim.startswith(v, cwd)
end

M.mru = function()
	local oldfiles = vim.tbl_filter(M.mru_filter, vim.v.oldfiles)
	local tbl = {}
	for i, fn in ipairs({ unpack(oldfiles, 1, 10) }) do
		local file_button_el = M.file_button(fn, tostring(i % 10))
		tbl[i] = file_button_el
	end
	return { {
		type = "group",
		val = tbl,
		opts = { position = "center" },
	} }
end

M.setup = function()
	local status_ok, alpha = pcall(require, "alpha")
	if not status_ok then
		vim.notify("Failed to load module 'alpha'", vim.log.levels.ERROR)
		return
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
			position = "center",
			hl = "DevIconVim",
		},
	}

	local function info_value()
		local total_plugins = #vim.tbl_keys(packer_plugins)
		local v = vim.version()
		return string.format("VIM: v%d.%d.%d PLUGINS: %d", v.major, v.minor, v.patch, total_plugins)
	end

	local info = {
		type = "text",
		val = info_value(),
		opts = {
			hl = "DevIconVim",
			position = "center",
		},
	}

	local message = {
		type = "text",
		val = fortune({ max_width = 60 }),
		opts = {
			position = "center",
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
				val = "MRU",
				opts = {
					hl = "String",
					shrink_margin = false,
					position = "center",
				},
			},
			{
				type = "group",
				val = M.mru,
				opts = {
					position = "center",
				},
			},
		},
	}

	local actions = {
		type = "group",
		val = {
			{
				type = "text",
				val = "CMD",
				opts = {
					hl = "String",
					shrink_margin = false,
					position = "center",
				},
			},
			M.button("e", "new", "<cmd>enew<cr>"),
			M.button("s", "session", "<cmd>SessionManager load_current_dir_session<cr>"),
			M.button("q", "quit", "<cmd>qa<cr>"),
		},
		opts = {
			position = "center",
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
		opts = {
			position = "center",
			width = 60,
		},
	}

	alpha.setup(config)

	vim.api.nvim_create_autocmd("User", {
		group = vim.api.nvim_create_augroup("alpha_user", { clear = true }),
		pattern = "BDeletePre",
		callback = function()
			if
				#vim.fn.getbufinfo({ buflisted = 1 }) < 2
				and vim.api.nvim_buf_get_name(0) ~= ""
				and vim.api.nvim_buf_get_option(0, "filetype") ~= "Alpha"
			then
				alpha.start(false)
			end
		end,
		desc = "Run Alpha when last buffer closed",
	})
end

return M
