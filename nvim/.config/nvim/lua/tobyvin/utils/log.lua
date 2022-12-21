local log = {}

local status_ok, Log = pcall(require, "plenary.log")
if status_ok then
	log = Log.new({ plugin = "notify" })
end

local levels = {}

for k, v in pairs(vim.log.levels) do
	levels[v] = k:lower()
	levels[k] = k:lower()
	levels[k:lower()] = k:lower()
end

setmetatable(log, {
	__call = function(t, m, l, o)
		local msg

		if type(m) == "table" then
			msg = table.concat(msg, "\n")
		else
			msg = m
		end

		if o and o.title then
			msg = string.format("%s: %s", o.title, msg)
		end

		local level = vim.F.if_nil(levels[l], "info")
		pcall(t[level], msg)

		vim.api.nvim_exec_autocmds("User", {
			pattern = "Notify",
			data = { m, l, o },
		})
	end,
})

vim.notify = log
