local utils = require("tobyvin.utils")

---@type LazyPluginSpec
local M = {
	"vxpm/ferris.nvim",
	config = true,
}

function M:init()
	utils.on_attach(function()
		require("ferris")
	end, { name = "rust_analyzer" })
end

return M
