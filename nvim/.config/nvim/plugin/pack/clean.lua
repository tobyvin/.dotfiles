local async = require("vim._async")
local api = vim.api
local uv = vim.uv

--- @param action string
--- @return fun(kind: 'begin'|'report'|'end', percent: integer, fmt: string, ...:any): nil
local function new_progress_report(action)
	local progress = { kind = "progress", title = "vim.pack" }

	return vim.schedule_wrap(function(kind, percent, fmt, ...)
		progress.status = kind == "end" and "success" or "running"
		progress.percent = percent
		local msg = ("%s %s"):format(action, fmt:format(...))
		progress.id = api.nvim_echo({ { msg } }, kind ~= "report", progress)
		-- Force redraw to show installation progress during startup
		vim.cmd.redraw({ bang = true })
	end)
end

local n_threads = 2 * #(uv.cpu_info() or { {} })
local copcall = package.loaded.jit and pcall or require("coxpcall").pcall

--- Execute function in parallel for each non-errored plugin in the list
--- @param plug_list vim.pack.Plug[]
--- @param f async fun(p: vim.pack.Plug)
--- @param progress_action string
local function run_list(plug_list, f, progress_action)
	local report_progress = new_progress_report(progress_action)

	-- Construct array of functions to execute in parallel
	local n_finished = 0
	local funs = {} --- @type (async fun())[]
	for _, p in ipairs(plug_list) do
		-- Run only for plugins which didn't error before
		if p.info.err == "" then
			--- @async
			funs[#funs + 1] = function()
				local ok, err = copcall(f, p) --[[@as string]]
				if not ok then
					p.info.err = err --- @as string
				end

				-- Show progress
				n_finished = n_finished + 1
				local percent = math.floor(100 * n_finished / #funs)
				report_progress("report", percent, "(%d/%d) - %s", n_finished, #funs, p.spec.name)
			end
		end
	end

	if #funs == 0 then
		return
	end

	-- Run async in parallel but wait for all to finish/timeout
	report_progress("begin", 0, "(0/%d)", #funs)

	--- @async
	local function joined_f()
		async.join(n_threads, funs)
	end
	async.run(joined_f):wait()

	report_progress("end", 100, "(%d/%d)", #funs, #funs)
end

vim.pack.clean = function(names)
	vim.validate("names", names, vim.islist, true, "list")
	---@param plug vim.pack.PlugData
	local paths = vim.iter(vim.pack.get(names, { info = false })):map(function(plug)
		return vim.fs.basename(plug.path)
	end)
	local plug_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack", "core", "opt")
	local plug_list = {}
	for name, type in vim.fs.dir(plug_dir) do
		local path = vim.fs.joinpath(plug_dir, name)
		if type == "directory" and not vim.tbl_contains(paths, path) then
			local plug = {
				info = {},
				spec = {
					name = name,
				},
				path = path,
			}
			table.insert(plug_list, plug)
		end
	end

	local do_clean = function(p)
		vim.fs.rm(p.path, { recursive = true, force = true })
	end

	run_list(plug_list, do_clean, "Cleaning plugins")
end
