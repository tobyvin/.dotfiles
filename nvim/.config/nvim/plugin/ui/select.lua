--- Additional options for `vim.ui.select`
---@class plugin.ui.select.Opts
---@field prompt string|nil Text of the prompt. Defaults to `Select one of:`
---@field format_item nil|fun(item: any): string Function to format an individual item from `items`. Defaults to `tostring`.
---@field kind string|nil Arbitrary hint string indicating the item shape.

---@generic T
---@param items T[] Arbitrary items
---@param opts plugin.ui.select.Opts|nil
---@param on_choice fun(item: T|nil, idx: integer|nil)
local function select(items, opts, on_choice)
	vim.validate("items", items, "table")
	vim.validate("opts", opts, "table", true)
	vim.validate("on_choice", on_choice, "function")
	opts = opts or {}
	vim.validate("opts.prompt", opts.prompt, "string", true)
	vim.validate("opts.format_item", opts.format_item, "function", true)
	vim.validate("opts.kind", opts.kind, "string", true)
	opts = vim.tbl_extend("keep", opts, {
		format_item = tostring,
		prompt = "Select",
	})

	if #items == 0 then
		return
	end

	local fmt_items = vim.iter(items):map(opts.format_item):totable()

	---@type vim.api.keyset.win_config
	local config = {
		width = vim.iter(fmt_items):map(vim.api.nvim_strwidth):fold(vim.api.nvim_strwidth(opts.prompt), math.max),
		height = math.min(#items, 10),
		zindex = 200,
		style = "minimal",
		title = opts.prompt,
	}

	if opts.kind == "codeaction" or opts.kind == "color_presentation" then
		config.relative = "cursor"
		config.row = 1
		config.col = 0
		if opts.kind == "codeaction" then
			---@cast items {action: lsp.Command|lsp.CodeAction, ctx: lsp.HandlerContext}[]
			config.footer = vim.lsp.get_client_by_id(items[1].ctx.client_id).name
		end
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
		-- vim.on_key(nil, ns_id, {})
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

	--- Attempt at search query in title bar
	-- vim.w[window].query = ""
	-- vim.on_key(function(key, _)
	-- 	key = vim.fn.keytrans(key)
	-- 	if key == "<BS>" then
	-- 		vim.w[window].query = string.sub(vim.w[window].query, 1, string.len(vim.w[window].query) - 1)
	-- 	elseif key == "<Space>" or vim.fn.strchars(key) == 1 and vim.fn.char2nr(key) > 31 then
	-- 		vim.w[window].query = vim.w[window].query .. key
	-- 	else
	-- 		return
	-- 	end
	--	-- TODO: filter buffer contents to matching results
	-- 	vim.api.nvim_win_set_config(window, {
	-- 		title = {
	-- 			{ opts.prompt .. " " },
	-- 			{ vim.w[window].query, "Float" },
	-- 		},
	-- 	})
	-- 	return ""
	-- end, ns_id, {})

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
