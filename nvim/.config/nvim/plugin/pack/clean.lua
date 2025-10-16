vim.pack.clean = function(names)
	names = vim.iter(vim.pack.get(names, { info = false }))
		:map(function(plug)
			if not plug.active then
				return plug.spec.name
			end
		end)
		:totable()
	if not vim.tbl_isempty(names) then
		vim.pack.del(names)
	end
end
