vim.pack.clean = function(names, opts)
	opts = opts or {}
	local inactive = {}
	names = vim.iter(vim.pack.get(names, { info = false }))
		:map(function(plug)
			if not plug.active then
				table.insert(inactive, plug.spec.name)
			end
			return plug.spec.name
		end)
		:totable()

	if opts.inactive and not vim.tbl_isempty(inactive) then
		vim.pack.del(inactive)
	end

	local plug_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack", "core", "opt")
	for name, type in vim.fs.dir(plug_dir) do
		if type == "directory" and not vim.tbl_contains(names, name) then
			vim.fs.rm(vim.fs.joinpath(plug_dir, name), { recursive = true, force = true })
			vim.notify(("vim.pack: Cleaned plugin '%s'"):format(name), vim.log.levels.INFO)
		end
	end
end
