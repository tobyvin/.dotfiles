local M = {}

setmetatable(M, {
	__index = function(_, k)
		local _, result = pcall(require, string.format("tobyvin.utils.%s", k))
		return result
	end,
})

return M
