local ms = vim.lsp.protocol.Methods

local on_list = function(what)
	vim.fn.setqflist({}, " ", what)
	vim.cmd.cfirst()
end

local M = {
	[ms.textDocument_hover] = {
		border = "single",
	},
	[ms.textDocument_signatureHelp] = {
		border = "single",
	},
	[ms.textDocument_definition] = {
		on_list = on_list,
	},
	[ms.textDocument_references] = {
		on_list = on_list,
	},
	[ms.textDocument_typeDefinition] = {
		on_list = on_list,
	},
	[ms.textDocument_implementation] = {
		on_list = on_list,
	},
}

return M
