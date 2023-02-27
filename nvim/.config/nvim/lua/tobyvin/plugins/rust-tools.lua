local M = {
	"simrat39/rust-tools.nvim",
	ft = "rust",
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-lua/plenary.nvim",
		"mfussenegger/nvim-dap",
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

local term_open = {
	command_buf = nil,
}

function term_open.execute_command(command, args, cwd)
	local utils = require("rust-tools.utils.utils")

	local full_command = utils.chain_commands({
		utils.make_command_from_args("cd", { cwd }),
		utils.make_command_from_args(command, args),
	})

	utils.delete_buf(term_open.buf)
	term_open.buf = vim.api.nvim_create_buf(false, true)
	utils.split(false, term_open.buf)

	-- make the new buffer smaller
	utils.resize(false, "-5")

	-- close the buffer
	vim.keymap.set("n", "q", function()
		utils.delete_buf(term_open.buf)
	end, { buffer = term_open.buf })

	-- run the command
	vim.fn.termopen(full_command)

	-- when the buffer is closed, set the latest buf id to nil else there are
	-- some edge cases with the id being sit but a buffer not being open
	local function onDetach(_, _)
		term_open.buf = nil
	end
	vim.api.nvim_buf_attach(term_open.buf, false, { on_detach = onDetach })
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

function M.config(_, opts)
	require("rust-tools").setup(opts)
	require("rust-tools.executors.termopen").execute_command = term_open.execute_command
end

return M
