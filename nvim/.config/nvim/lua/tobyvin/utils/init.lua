-- Lazy load
local M = {}

function M.require(mod)
	local ok, ret = M.try(require, mod)
	return ok and ret
end

function M.try(fn, ...)
	local args = { ... }

	return xpcall(function()
		return fn(unpack(args))
	end, function(err)
		local lines = {}
		table.insert(lines, err)
		table.insert(lines, debug.traceback("", 3))

		M.error(table.concat(lines, "\n"))
		return err
	end)
end

setmetatable(M, {
	__index = function(t, k)
		local ok, val = pcall(require, string.format("tobyvin.utils.%s", k))

		if ok then
			rawset(t, k, val)
		end

		return val
	end,
})

return M
