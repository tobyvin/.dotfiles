do
	--- Additional options for `vim.ui.select`
	---@class plugin.ui.select_opts
	---@field prompt string|nil Text of the prompt. Defaults to `Select one of:`
	---@field format_item nil|fun(item: any): string Function to format an individual item from `items`. Defaults to `tostring`.
	---@field kind string|nil Arbitrary hint string indicating the item shape.

	---@generic T
	---@param items T[] Arbitrary items
	---@param opts plugin.ui.select_opts | nil
	---@param on_choice fun(item: T|nil, idx: integer|nil)
	local function select(items, opts, on_choice)
		vim.validate("items", items, "table")
		vim.validate("opts", opts, { "table", "nil" })
		vim.validate("on_choice", on_choice, "function")

		if #items == 0 then
			return
		end

		---@type plugin.ui.select_opts
		opts = vim.tbl_extend("keep", opts or {}, {
			format_item = tostring,
			prompt = "Select",
		})

		local fmt_items = vim.iter(items):map(opts.format_item):totable()

		---@type vim.api.keyset.win_config
		local config = {
			width = vim.iter(fmt_items):map(vim.api.nvim_strwidth):fold(vim.api.nvim_strwidth(opts.prompt), math.max),
			height = math.min(#items, 10),
			zindex = 200,
			style = "minimal",
			title = opts.prompt,
		}

		if opts.kind == "codeaction" then
			---@cast items {action: lsp.Command|lsp.CodeAction, ctx: lsp.HandlerContext}[]
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
		vim.api.nvim_set_hl(ns_id, "CursorLine", { reverse = true })
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

		vim.opt.guicursor:append("n:hor1")

		local function cancel()
			vim.opt.guicursor:remove("n:hor1")
			if vim.api.nvim_win_is_valid(window) then
				vim.api.nvim_win_close(window, true)
			end
		end

		local function choose()
			local row = unpack(vim.api.nvim_win_get_cursor(window))
			cancel()
			on_choice(items[row], row)
		end

		vim.keymap.set({ "n", "v" }, "<cr>", choose, { buffer = buffer })
		vim.keymap.set({ "n", "v" }, "<2-LeftMouse>", choose, { buffer = buffer })
		vim.keymap.set({ "n", "v" }, "q", cancel, { buffer = buffer })
		vim.keymap.set({ "n" }, "<esc>", cancel, { buffer = buffer })
		vim.api.nvim_create_autocmd({ "BufLeave" }, {
			buffer = buffer,
			callback = cancel,
		})

		if opts.kind == "codeaction" then
			vim.api.nvim_create_autocmd({ "CursorMoved" }, {
				buffer = buffer,
				callback = function()
					local row = unpack(vim.api.nvim_win_get_cursor(window))
					vim.api.nvim_win_set_config(window, {
						footer = vim.lsp.get_client_by_id(items[row].ctx.client_id).name,
					})
				end,
			})
		end
	end

	vim.ui.select = select
end

do
	--- Additional options for `vim.ui.select`
	---@class plugin.ui.input_opts
	---@field prompt string|nil Text of the prompt
	---@field default string|nil Default reply to the input
	---@field completion string|nil Specifies type of completion supported for input. Supported types are the same that can be supplied to a user-defined command using the "-complete=" argument. See |:command-completion|
	---@field highlight function|nil Function that will be used for highlighting user inputs.

	---@param opts plugin.ui.input_opts | nil
	---@param on_confirm fun(input: string|nil)
	local function input(opts, on_confirm)
		vim.validate("opts", opts, { "table", "nil" })
		vim.validate("on_confirm", on_confirm, "function")

		---@type plugin.ui.input_opts
		opts = vim.tbl_extend("keep", opts or {}, {
			prompt = "Input",
		})

		---@type vim.api.keyset.win_config
		local config = {
			relative = "cursor",
			width = math.max(vim.api.nvim_strwidth(opts.prompt or ""), 20),
			height = 1,
			row = 1,
			col = 0,
			zindex = 200,
			style = "minimal",
			title = opts.prompt,
		}

		local buffer = vim.api.nvim_create_buf(false, true)
		local window = vim.api.nvim_open_win(buffer, true, config)

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
							vim.api.nvim_echo({
								{ ("Could not find completion function %s: %s"):format(vimfunc, err) },
							}, true, { err = true })
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

	vim.ui.input = input
end
