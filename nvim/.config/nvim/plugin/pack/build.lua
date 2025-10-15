vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("build_system", { clear = true }),
	pattern = "*",
	callback = function(args)
		local pkg = args.data
		local build = (pkg.spec.data or {}).build
		if pkg.kind == "update" then
			if type(build) == "function" then
				pcall(build, pkg)
			elseif type(build) == "string" then
				pcall(vim.cmd[build])
			elseif type(build) == "table" then
				vim.system({ "sh" }, {
					cwd = pkg.path,
					stdin = table.concat(build, " "),
				})
			end
		end
	end,
})
