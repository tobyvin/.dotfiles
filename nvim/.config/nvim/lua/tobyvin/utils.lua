local M = {
	buf = require("tobyvin.utils.buf"),
	fs = require("tobyvin.utils.fs"),
	lsp = require("tobyvin.utils.lsp"),
	session = require("tobyvin.utils.session"),
	ui = require("tobyvin.utils.ui"),
}

---@param ms integer
---@param fn function
function M.debounce(ms, fn)
	local timer = vim.uv.new_timer()
	return function(...)
		local argv = { ... }
		timer:start(ms, 0, function()
			timer:stop()
			vim.schedule_wrap(fn)(unpack(argv))
		end)
	end
end

return M
