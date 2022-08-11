local utils = require("tobyvin.utils")
local M = {}

M.setup = function()
	vim.lsp.handlers["textDocument/definition"] = function(_, result)
		if not result or vim.tbl_isempty(result) then
			vim.notify("[LSP] Could not find definition", "info")
			return
		end

		if vim.tbl_islist(result) then
			vim.lsp.util.jump_to_location(result[1], "utf-8", true)
		else
			vim.lsp.util.jump_to_location(result, "utf-8", true)
		end
	end

	vim.lsp.handlers["textDocument/publishDiagnostics"] =
		vim.lsp.with(vim.lsp.handlers["textDocument/publishDiagnostics"], {
			signs = {
				severity_limit = "Error",
			},
			underline = {
				severity_limit = "Warning",
			},
			update_in_insert = true,
			virtual_text = true,
		})

	-- vim.lsp.handlers["$/progress"] = function(_, result, ctx)
	-- 	local client_id = ctx.client_id
	-- 	local val = result.value
	-- 	if val.kind then
	-- 		if not utils.client_notifs[client_id] then
	-- 			utils.client_notifs[client_id] = {}
	-- 		end
	-- 		local notif_data = utils.client_notifs[client_id][result.token]
	-- 		if val.kind == "begin" then
	-- 			local message = utils.format_message(val.message, val.percentage)
	-- 			local notification = vim.notify(message, "info", {
	-- 				title = utils.format_title(val.title, vim.lsp.get_client_by_id(client_id)),
	-- 				icon = utils.progress_signs.spinner.text[1],
	-- 				timeout = false,
	-- 				hide_from_history = false,
	-- 			})
	-- 			utils.client_notifs[client_id][result.token] = {
	-- 				notification = notification,
	-- 				spinner = 1,
	-- 			}
	-- 			utils.update_spinner(client_id, result.token)
	-- 		elseif val.kind == "report" and notif_data then
	-- 			local new_notif = vim.notify(
	-- 				utils.format_message(val.message, val.percentage),
	-- 				"info",
	-- 				{ replace = notif_data.notification, hide_from_history = false }
	-- 			)
	-- 			utils.client_notifs[client_id][result.token] = {
	-- 				notification = new_notif,
	-- 				spinner = notif_data.spinner,
	-- 			}
	-- 		elseif val.kind == "end" and notif_data then
	-- 			local new_notif = vim.notify(
	-- 				val.message and utils.format_message(val.message) or "Complete",
	-- 				"info",
	-- 				{ icon = utils.progress_signs.complete.text, replace = notif_data.notification, timeout = 3000 }
	-- 			)
	-- 			utils.client_notifs[client_id][result.token] = {
	-- 				notification = new_notif,
	-- 			}
	-- 		end
	-- 	end
	-- end

	vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
		vim.notify({ result.message }, 5 - result.type, {
			title = "[LSP] " .. vim.lsp.get_client_by_id(ctx.client_id),
			timeout = 2500,
		})
	end
end

return M
