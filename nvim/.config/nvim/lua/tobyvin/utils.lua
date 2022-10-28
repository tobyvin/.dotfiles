-- Lazy load
local M = setmetatable({}, {
	__index = function(t, k)
		local ok, val = pcall(require, string.format("tobyvin.utils.%s", k))

		if ok then
			rawset(t, k, val)
		end

		return val
	end,
})

return M
