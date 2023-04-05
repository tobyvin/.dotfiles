local M = {
	"simrat39/rust-tools.nvim",
	ft = "rust",
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-lua/plenary.nvim",
	},
	opts = {
		tools = {
			hover_actions = {
				border = "single",
			},
		},
		server = require("tobyvin.lsp.configs").rust_analyzer,
		dap = { adapter = require("tobyvin.plugins.dap.adapters").codelldb },
	},
	config = true,
}

local function set_target()
	local Job = require("plenary.job")
	local targets = Job:new({
		command = "rustc",
		args = { "--print=target-list" },
		enable_recording = true,
	}):sync()
	table.insert(targets, 1, "default")

	vim.ui.select(targets, {}, function(input)
		if not input then
			return
		end

		if input == "default" then
			input = nil
		end

		---@diagnostic disable-next-line: assign-type-mismatch
		for _, client in pairs(vim.lsp.get_active_clients({ name = "rust_analyzer" })) do
			client.config.settings["rust-analyzer"].cargo.target = input
			client.notify("workspace/didChangeConfiguration", {
				settings = client.config.settings,
			})

			-- TODO: Figure out how to do this without defer, or maybe even reloading.
			-- The workspace seems to need to be reloaded after the notification due to the
			-- [inactive-code] diagnostic, but the request being processed before the
			-- notification is completed, so I can only get it to work by defering. This is
			-- technically still a race condition?
			vim.defer_fn(function()
				client.request("rust-analyzer/reloadWorkspace", nil, function(err)
					if err then
						error(tostring(err))
					end
					vim.notify("Cargo workspace reloaded")
				end, 0)
			end, 500)
		end
	end)
end

function M.init()
	require("tobyvin.lsp.configs").rust_analyzer = nil

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("rust-tools", {}),
		desc = "setup rust-tools",
		callback = function(args)
			if vim.lsp.get_client_by_id(args.data.client_id).name ~= "rust_analyzer" then
				return
			end

			vim.api.nvim_create_user_command("RustSetTarget", set_target, { desc = "Set cargo target" })

			vim.keymap.set("n", "<leader>dd", require("rust-tools").debuggables.debuggables, {
				desc = "debug",
				buffer = args.buf,
			})
			vim.keymap.set("n", "<leader>tt", require("rust-tools").runnables.runnables, {
				desc = "test",
				buffer = args.buf,
			})
			vim.keymap.set("n", "<leader>le", require("rust-tools").expand_macro.expand_macro, {
				desc = "expand macro",
				buffer = args.buf,
			})
		end,
	})
end

return M
