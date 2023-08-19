-- Metadata
-- languages: python,go,php,html
-- url: https://djlint.com/

local fs = require("efmls-configs.fs")

local linter = "markdownlint"
local bin = fs.executable(linter)
local args = ("--stdin --config %s/markdownlint/markdownlint.yaml"):format(vim.env.XDG_CONFIG_HOME)
local command = string.format("%s %s", bin, args)

return {
	prefix = linter,
	lintCommand = command,
	lintFormats = { "%f:%l %m", "%f:%l:%c %m", "%f: %l: %m" },
	lintStdin = true,
	lintIgnoreExitCode = true,
}
