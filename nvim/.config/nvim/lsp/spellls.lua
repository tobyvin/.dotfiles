local ms = vim.lsp.protocol.Methods

---@alias spellls.Kind
---| 'bad'
---| 'rare'
---| 'local'
---| 'caps'

---@class spellls.Item
---@field word string
---@field kind spellls.Kind
---@field lnum integer
---@field col integer

---@type table<spellls.Kind, lsp.DiagnosticSeverity>
local severity = {
	bad = vim.diagnostic.severity.ERROR,
	cap = vim.diagnostic.severity.HINT,
	["local"] = vim.diagnostic.severity.HINT,
	rare = vim.diagnostic.severity.WARN,
}

-- TODO: figure out how to publish diagnostics
local server = vim.lsp.server({
	capabilities = {
		codeActionProvider = true,
		diagnosticProvider = true,
	},
	handlers = {
		---@param params lsp.PublishDiagnosticsParams
		---@param callback fun(err: nil, report: lsp.DocumentDiagnosticReport)
		[ms.textDocument_publishDiagnostics] = function(_, params, callback)
			---@type lsp.DocumentDiagnosticReport
			local report = {
				kind = "unchanged",
				items = {},
			}

			for lnum, line in pairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
				for _, result in ipairs(vim.spell.check(line)) do
					local word, kind, col = unpack(result)
					table.insert(report.items, {
						range = {
							start = {
								line = lnum,
								character = col,
							},
							["end"] = {
								line = lnum,
								character = col + #word,
							},
						},
						severity = severity[kind],
						codeDescription = nil,
						code = ("spell-%s"):format(kind),
						source = "spellls",
						message = ("Possible spelling error: '%s'"):format(word),
						tags = nil,
						relatedInformation = nil,
						data = {
							word = word,
							kind = kind,
							lnum = lnum,
							col = col,
						} --[[@type spellls.Item]],
					} --[[@type lsp.Diagnostic]])
				end
			end

			callback(nil, report)
		end,

		---@param callback fun(err: nil, actions: lsp.CodeAction[])
		[ms.textDocument_codeAction] = function(_, _, callback)
			local lnum = vim.fn.line(".")
			local col = vim.fn.col(".")

			local client = vim.lsp.get_clients({ bufnr = 0, name = "spellls" })[1]
			local ns = vim.lsp.diagnostic.get_namespace(client.id, true)
			local diagnostics = vim.diagnostic.get(0, { namespace = ns, lnum = lnum })

			local actions = vim.iter(diagnostics)
				:filter(function(diag)
					return col >= diag.col and col <= diag.end_col
				end)
				:map(function(diag)
					return {
						title = ("Fix spelling: '%s'"):format(diag.user_data.word),
						kind = "quickfix",
						command = {
							title = "Spell check",
							command = "spell_check",
							arguments = diag.user_data,
						},
					}
				end)
				:totable()

			callback(nil, actions)
		end,
	},
	on_exit = function(_, _, client_id)
		if vim.lsp.get_client_by_id(client_id).name == "spellls" then
			vim.lsp.stop_client(client_id)
		end
	end,
})

---@type vim.lsp.Config
return {
	cmd = server,
	filetypes = {},
	commands = {
		["spell_check"] = function(cmd, ctx)
			---@type spellls.Item
			local args = cmd.arguments

			vim.print("Running example action", args, ctx)
		end,
	},
}
