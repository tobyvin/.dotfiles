---@diagnostic disable-next-line: param-type-mismatch
vim.opt_local.formatoptions:remove("o")

vim.treesitter.query.set(
	"rust",
	"cargo-test",
	[[
      (
        (
          mod_item name: (identifier) @test-name
          (#match? @test-name "[Tt]est")
        )
      @scope-root)

      (
        (
          function_item name: (identifier) @test-name
          (#match? @test-name "[Tt]est")
        )
      @scope-root)
    ]]
)

local cargotest = {
	config = {
		command = "cargo",
		args = { "test" },
		package = true,
	},
}

-- Build command list
---@return string command
---@return table args
---@return string test
function cargotest:build_cmd(filename, opts)
	local args = {}
	for _, arg in ipairs(self.config.args) do
		table.insert(args, arg)
	end
	local modpath = self:build_args(args, filename, opts or {})
	return self.config.command, args, modpath
end

---@return string test
function cargotest:build_args(args, filename, opts)
	if not filename then
		return "::"
	end

	local cargo = vim.fn.findfile("Cargo.toml", vim.fn.fnamemodify(filename, ":p") .. ";")
	local crate = vim.fn.fnamemodify(cargo, ":p:h") or ""

	if self.config.package then
		if crate and #crate > 0 then
			table.insert(args, "-p")
			table.insert(args, vim.fn.fnamemodify(crate, ":t"))
		end
	end

	local file = vim.fn.fnamemodify(filename, ":.:r"):gsub(crate, "") or ""
	local parts = vim.fn.split(file, "/")
	if parts[#parts] == "main" or parts[#parts] == "lib" or parts[#parts] == "mod" then
		parts[#parts] = nil
	end
	if parts[1] == "src" then
		table.remove(parts, 1)
	end

	local modname
	if #parts > 0 then
		modname = table.concat(parts, "::")
	end

	local modpath

	if opts.tests and #opts.tests > 0 then
		if modname then
			table.insert(opts.tests, 1, modname)
		end
		modpath = table.concat(opts.tests, "::")
		table.insert(args, modpath)
		table.insert(args, "--")
		table.insert(args, "--exact")
	else
		if modname and #modname > 0 then
			modpath = modname .. "::"
			table.insert(args, modpath)
		end
	end
	return modpath
end

local function get_node_at_cursor()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local line = cursor[1] - 1
	local col = cursor[2]
	local parser = vim.treesitter.get_parser()
	if not parser then
		return
	end
	local lang_tree = parser:language_for_range({ line, col, line, col })
	for _, tree in ipairs(lang_tree:trees()) do
		local root = tree:root()
		local node = root:named_descendant_for_range(line, col, line, col)
		if node then
			return node
		end
	end
end

function cargotest:find_nearest_test()
	local query = vim.treesitter.query.get("rust", "cargo-test")
	local result = {}
	local test_node
	if query then
		local curnode = get_node_at_cursor()
		while curnode do
			---@diagnostic disable-next-line: missing-parameter
			local iter = query:iter_captures(curnode, 0)
			local capture_id, capture_node = iter()

			if capture_node == curnode and query.captures[capture_id] == "scope-root" then
				while query.captures[capture_id] ~= "test-name" do
					capture_id, capture_node = iter()
					if not capture_id then
						return result
					end
				end

				if test_node == nil then
					test_node = capture_node
				end

				local name = vim.treesitter.get_node_text(capture_node, 0)
				table.insert(result, 1, name)
			end
			curnode = curnode:parent()
		end
	end
	return test_node, result
end

local M = {
	id = 1,
	ids = {},
}

function M.run()
	local filename = nil

	-- Find file
	filename = vim.fn.expand("%:.") --[[@as string]]

	-- Find the current working directory
	local cwd = cargotest.config.working_directory
	if filename and cwd and #cwd > 0 then
		filename = string.gsub(filename, "^" .. cwd .. "/", "", 1)
	end

	local test_node, tests = cargotest:find_nearest_test()

	local lnum, col = vim.treesitter.get_node_range(test_node)
	local command, args, modpath = cargotest:build_cmd(filename, {
		tests = tests,
	})

	M.run_cmd(0, lnum, col, modpath, {
		command = command,
		args = args,
		cwd = cwd,
	})
end

--- Run the given command
---
---@param bufnr integer
---@param lnum integer
---@param col integer
---@param modpath string
---@param job_opts table: a command to run
function M.run_cmd(bufnr, lnum, col, modpath, job_opts)
	if bufnr == 0 then
		bufnr = vim.api.nvim_get_current_buf()
	end

	vim.b[bufnr].last_test = {
		bufnr = bufnr,
		lnum = lnum,
		col = col,
		modpath = modpath,
		job_opts = job_opts,
	}

	job_opts.on_exit = vim.schedule_wrap(function(j, code)
		local ns = vim.api.nvim_create_namespace("cargo-test")
		local virt_lines = {}
		local capture = false
		local hl

		if code == 0 then
			hl = "DiagnosticOk"
		else
			hl = "DiagnosticError"
		end

		for _, line in pairs(j:result()) do
			if line:match("^test result: ") then
				capture = false
			elseif line:match("^running 1 test") then
				capture = true
			elseif capture then
				table.insert(virt_lines, { { string.rep(" ", col - 3) .. line, hl } })
			end
		end

		table.remove(virt_lines, #virt_lines)
		M.ids[modpath] = vim.api.nvim_buf_set_extmark(bufnr, ns, lnum, col, {
			id = M.ids[modpath],
			virt_lines = virt_lines,
			virt_lines_above = true,
		})
	end)

	local job = require("plenary.job"):new(job_opts)

	job:start()
end

vim.keymap.set("n", "<leader>tt", M.run, { desc = "run closest test" })
