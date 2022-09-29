local M = {}

M.setup = function()
	local status_ok, alpha = pcall(require, "alpha")
	if not status_ok then
		vim.notify("Failed to load module 'alpha'", vim.log.levels.ERROR)
		return
	end

	local startify = require("alpha.themes.startify")
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
			position = "left",
			hl = "DevIconVim",
		},
	}

	local function info_value()
		local total_plugins = #vim.tbl_keys(packer_plugins)
		local datetime = os.date(" %d-%m-%Y")
		local v = vim.version()
		return "DATE: "
			.. datetime
			.. " VIM: v"
			.. v.major
			.. "."
			.. v.minor
			.. "."
			.. v.patch
			.. " PLUGINS: "
			.. total_plugins
	end

	local info = {
		type = "text",
		val = info_value(),
		opts = {
			hl = "DevIconVim",
			position = "left",
		},
	}

	local message = {
		type = "text",
		val = fortune({ max_width = 60 }),
		opts = {
			position = "left",
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
					position = "left",
					max_width = 60,
				},
			},
			{
				type = "group",
				val = function()
					return { startify.mru(1, vim.fn.getcwd(), 5) }
				end,
			},
		},
	}

	local buttons = {
		type = "group",
		val = {
			{
				type = "text",
				val = "CMD",
				opts = {
					hl = "String",
					shrink_margin = false,
					position = "left",
				},
			},
			{ type = "padding", val = 1 },
			startify.button("e", "new", "<cmd>enew<cr>"),
			startify.button("s", "session", "<cmd>SessionManager load_current_dir_session<cr>"),
			startify.button("q", "quit", "<cmd>qa<cr>"),
		},
		opts = {
			position = "left",
		},
	}

	local config = {
		layout = {
			header,
			{ type = "padding", val = 1 },
			mru,
			{ type = "padding", val = 1 },
			buttons,
		},
		opts = {
			position = "center",
			width = 50,
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
