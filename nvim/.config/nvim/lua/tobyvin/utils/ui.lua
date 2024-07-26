local M = {}

function M.select(items, opts, on_choice)
	vim.validate({
		items = { items, "table", false },
		opts = { opts, { "table", "nil" }, false },
		on_choice = { on_choice, "function", false },
	})

	opts = vim.tbl_extend("keep", opts or {}, {
		format_item = tostring,
		prompt = "Select",
	})

	local fmt_items = vim.iter(items)
		:map(function(item)
			local text = opts.format_item(item)
			return text
		end)
		:totable()

	---@type vim.api.keyset.win_config
	local config = {
		width = vim.iter(fmt_items):map(vim.api.nvim_strwidth):fold(vim.api.nvim_strwidth(opts.prompt), math.max),
		height = math.min(#items, 10),
		zindex = 200,
		style = "minimal",
		border = "single",
		title = opts.prompt,
	}

	if opts.kind == "codeaction" then
		config.relative = "cursor"
		config.row = 1
		config.col = 0
		config.footer = vim.lsp.get_client_by_id(items[1].ctx.client_id).name
	else
		config.relative = "editor"
		config.col = math.floor((vim.o.columns - config.width) / 2)
		config.row = math.floor((vim.o.lines - vim.o.cmdheight - config.height) / 2)
	end

	local buffer = vim.api.nvim_create_buf(false, true)
	local window = vim.api.nvim_open_win(buffer, true, config)

	local ns_id = vim.api.nvim_create_namespace("select")
	vim.api.nvim_buf_add_highlight(buffer, ns_id, "Pmenu", 0, 0, -1)
	vim.api.nvim_set_hl(ns_id, "CursorLine", { link = "PmenuSel" })
	vim.api.nvim_set_hl(ns_id, "Cursor", { cterm = nil, gui = nil, blend = 100 })
	vim.api.nvim_win_set_hl_ns(window, ns_id)

	vim.api.nvim_buf_set_lines(buffer, 0, 0, false, fmt_items)
	vim.api.nvim_buf_set_lines(buffer, -2, -1, false, {})

	vim.api.nvim_set_option_value("modifiable", false, { buf = buffer })
	vim.api.nvim_set_option_value("filetype", "select", { buf = buffer })
	vim.api.nvim_set_option_value("swapfile", false, { buf = buffer })
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buffer })
	vim.api.nvim_set_option_value("scrolloff", 0, { win = window })
	vim.api.nvim_set_option_value("cursorline", true, { win = window })

	vim.api.nvim_win_set_cursor(window, { 1, 0 })
	local guicursor = vim.o.guicursor
	vim.opt.guicursor = "a:noCursor"

	local function make_on_choice(choosen)
		return function()
			local row = unpack(vim.api.nvim_win_get_cursor(window))
			if vim.api.nvim_win_is_valid(window) then
				vim.api.nvim_win_close(window, true)
			end
			vim.opt.guicursor = guicursor
			if choosen then
				on_choice(items[row], row)
			else
				on_choice(nil, nil)
			end
		end
	end

	vim.keymap.set({ "n", "v" }, "<cr>", make_on_choice(true), { buffer = buffer })
	vim.keymap.set({ "n", "v" }, "<2-LeftMouse>", make_on_choice(true), { buffer = buffer })
	vim.keymap.set({ "n", "v" }, "<esc>", make_on_choice(false), { buffer = buffer })
	vim.keymap.set({ "n", "v" }, "q", make_on_choice(false), { buffer = buffer })
	vim.api.nvim_create_autocmd({ "BufLeave" }, {
		buffer = buffer,
		callback = make_on_choice(false),
	})

	vim.api.nvim_create_autocmd({ "CursorMoved" }, {
		buffer = buffer,
		callback = function()
			local row = unpack(vim.api.nvim_win_get_cursor(window))
			if items[row].ctx then
				vim.api.nvim_win_set_config(window, {
					footer = vim.lsp.get_client_by_id(items[row].ctx.client_id).name,
				})
			end
		end,
	})
end

function M.input(opts, on_confirm)
	vim.validate({
		opts = { opts, { "table", "nil" }, true },
		on_confirm = { on_confirm, "function", false },
	})

	opts = vim.tbl_extend("keep", opts or {}, {
		prompt = "Input",
	})

	M.completion = opts.completion

	local config = {
		relative = "cursor",
		width = math.max(vim.api.nvim_strwidth(opts.prompt or ""), 20),
		height = 1,
		row = 1,
		col = 0,
		zindex = 200,
		style = "minimal",
		border = "single",
		title = opts.prompt,
	}

	local buffer = vim.api.nvim_create_buf(false, true)
	local window = vim.api.nvim_open_win(buffer, true, config)
	local ns_id = vim.api.nvim_create_namespace("select")

	vim.b[buffer].completefunc = function(findstart, base)
		if not opts.completion then
			return findstart == 1 and 0 or {}
		end
		if findstart == 1 then
			return 0
		else
			local pieces = vim.split(opts.completion, ",", { plain = true })
			if pieces[1] == "custom" or pieces[1] == "customlist" then
				local vimfunc = pieces[2]
				local ret
				if vim.startswith(vimfunc, "v:lua.") then
					local load_func = string.format("return %s(...)", vimfunc:sub(7))
					local luafunc, err = loadstring(load_func)
					if not luafunc then
						vim.api.nvim_err_writeln(
							string.format("Could not find completion function %s: %s", vimfunc, err)
						)
						return {}
					end
					ret = luafunc(base, base, vim.fn.strlen(base))
				else
					ret = vim.fn[vimfunc](base, base, vim.fn.strlen(base))
				end
				if pieces[1] == "custom" then
					ret = vim.split(ret, "\n", { plain = true })
				end
				return ret
			else
				local ok, result = pcall(vim.fn.getcompletion, base, opts.completion)
				return ok and result or {}
			end
		end
	end

	vim.api.nvim_buf_add_highlight(buffer, ns_id, "Pmenu", 0, 0, -1)
	vim.api.nvim_set_hl(ns_id, "CursorLine", { link = "PmenuSel" })
	vim.api.nvim_win_set_hl_ns(window, ns_id)

	vim.api.nvim_buf_set_lines(buffer, 0, 0, false, { opts.default })
	vim.api.nvim_buf_set_lines(buffer, -2, -1, false, {})

	vim.api.nvim_set_option_value("filetype", "input", { buf = buffer })
	vim.api.nvim_set_option_value("swapfile", false, { buf = buffer })
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buffer })
	vim.api.nvim_set_option_value("scrolloff", 0, { win = window })
	vim.api.nvim_set_option_value("completefunc", "v:lua.vim.b.completefunc", { buf = buffer })
	vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.b.completefunc", { buf = buffer })

	vim.cmd.startinsert({ bang = true })

	vim.keymap.set("i", "<cr>", function()
		local text = vim.api.nvim_buf_get_lines(buffer, 0, 1, false)[1]

		if vim.fn.pumvisible() == 1 then
			local escape_key = vim.api.nvim_replace_termcodes("<C-e>", true, false, true)
			vim.api.nvim_feedkeys(escape_key, "n", true)
		end

		vim.cmd.stopinsert()
		vim.defer_fn(function()
			pcall(vim.api.nvim_win_close, window, true)
			vim.defer_fn(function()
				on_confirm(text)
			end, 5)
		end, 5)
	end, { buffer = buffer })

	vim.api.nvim_create_autocmd({ "BufLeave", "InsertLeave" }, {
		desc = "Cancel vim.ui.input",
		buffer = buffer,
		nested = true,
		once = true,
		callback = function()
			pcall(vim.api.nvim_win_close, window, true)
			on_confirm(nil)
		end,
	})
end

return M
