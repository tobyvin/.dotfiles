vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("build_system", { clear = true }),
	pattern = "*",
	callback = function(args)
		local pkg = args.data
		local build = (pkg.spec.data or {}).build
		local success, res
		-- HACK: fix for vim.pack not printing newlines when --headless
		if #vim.api.nvim_list_uis() == 0 then
			vim.print("\n")
		end
		if type(build) == "table" and pkg.kind == "install" or pkg.kind == "update" then
			success, res = pcall(vim.system, build, { cwd = pkg.path })
			if success and #vim.api.nvim_list_uis() == 0 then
				res:wait(300000)
			end
		elseif pkg.kind == "update" then
			if not pkg.active then
				vim.cmd.packadd(pkg.spec.name)
			end
			if type(build) == "function" then
				success, res = pcall(build, pkg)
			elseif type(build) == "string" then
				success, res = pcall(vim.cmd[build])
			end
		end

		if success == false then
			vim.notify(
				("Failed to build - %s: %s"):format(pkg.spec.name, res),
				vim.log.levels.ERROR,
				{ title = "vim.pack" }
			)
			return
		end
	end,
})
