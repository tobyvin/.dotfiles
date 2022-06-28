local M = {}

M.setup = function()
	vim.lsp.handlers["textDocument/definition"] = function(_, result)
		if not result or vim.tbl_isempty(result) then
			vim.notify("[LSP] Could not find definition", "info")
			return
		end

		if vim.tbl_islist(result) then
			vim.lsp.util.jump_to_location(result[1], "utf-8")
		else
			vim.lsp.util.jump_to_location(result, "utf-8")
		end
	end

	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
		vim.lsp.handlers["textDocument/publishDiagnostics"],
		{
			signs = {
				severity_limit = "Error",
			},
			underline = {
				severity_limit = "Warning",
			},
			update_in_insert = true,
			virtual_text = true,
		}
	)

	vim.lsp.handlers["$/progress"] = function(_, result, ctx)
		local utils = require("tobyvin.lsp.utils")
		local client_id = ctx.client_id
		local val = result.value

		if not val.kind then
			return
		end

		local notif_data = utils.get_notif_data(client_id, result.token)

		if val.kind == "begin" then
			local message = utils.format_message(val.message, val.percentage)

			notif_data.notification = vim.notify(message, "info", {
				title = utils.format_title(val.title, vim.lsp.get_client_by_id(client_id).name),
				icon = utils.spinner_frames[1],
				timeout = false,
				hide_from_history = false,
			})

			notif_data.spinner = 1
			utils.update_spinner(client_id, result.token)
		elseif val.kind == "report" and notif_data then
			notif_data.notification = vim.notify(utils.format_message(val.message, val.percentage), "info", {
				replace = notif_data.notification,
				hide_from_history = false,
			})
		elseif val.kind == "end" and notif_data then
			notif_data.notification = vim.notify(
				val.message and utils.format_message(val.message) or "Complete",
				"info",
				{
					icon = "",
					replace = notif_data.notification,
					timeout = 3000,
				}
			)

			notif_data.spinner = nil
		end
	end

	vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
		local client = vim.lsp.get_client_by_id(ctx.client_id)
		local lvl = ({
			"ERROR",
			"WARN",
			"INFO",
			"DEBUG",
		})[result.type]

		vim.notify({ result.message }, lvl, {
			title = "LSP | " .. client.name,
			timeout = 10000,
			keep = function()
				return lvl == "ERROR" or lvl == "WARN"
			end,
		})
	end
end

return M
