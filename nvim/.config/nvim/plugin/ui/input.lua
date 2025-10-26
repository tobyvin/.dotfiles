--- Additional options for `vim.ui.select`
---@class plugin.ui.input.Opts
---@field prompt string|nil Text of the prompt
---@field default string|nil Default reply to the input
---@field completion string|nil Specifies type of completion supported for input. Supported types are the same that can be supplied to a user-defined command using the "-complete=" argument. See |:command-completion|
---@field highlight function|nil Function that will be used for highlighting user inputs.

---@param opts plugin.ui.input.Opts|nil
---@param on_confirm fun(input: string|nil)
local function input(opts, on_confirm)
	vim.validate("opts", opts, "table", true)
	vim.validate("on_confirm", on_confirm, "function")
	opts = opts or {}
	vim.validate("opts.prompt", opts.prompt, "string", true)
	vim.validate("opts.default", opts.default, "string", true)
	vim.validate("opts.completion", opts.completion, "string", true)
	vim.validate("opts.highlight", opts.highlight, "function", true)
	opts = vim.tbl_extend("keep", opts, {
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
