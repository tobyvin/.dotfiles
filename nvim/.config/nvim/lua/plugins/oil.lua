---@type LazyPluginSpec
local M = {
	"stevearc/oil.nvim",
	version = "*",
	cmd = { "Oil" },
	event = { "BufNew", "ColorScheme" },
	opts = {
		default_file_explorer = true,
		skip_confirm_for_simple_edits = true,
		view_options = {
			show_hidden = true,
		},
	},
}

function M:init()
	vim.keymap.set("n", "-", function()
		require("oil").open()
	end, { desc = "Open parent directory" })

	vim.api.nvim_create_autocmd("User", {
		group = vim.api.nvim_create_augroup("tobyvin_oil", { clear = true }),
		pattern = "SessionSavePre",
		callback = function(args)
			if vim.bo[args.buf].filetype == "oil" then
				require("oil").close()
				local has_orig_alt, alt_buffer = pcall(vim.api.nvim_win_get_var, 0, "oil_original_alternate")
				if has_orig_alt and vim.api.nvim_buf_is_valid(alt_buffer) then
					vim.fn.setreg("#", alt_buffer)
				end
			end
		end,
		desc = "close oil buffer on session save",
	})

	if vim.fn.argc() == 1 then
		arg = vim.fn.argv(0) --[[@as string]]
		local stat = vim.loop.fs_stat(arg)
		local adapter = string.match(arg, "^([%l-]*)://")
		if (stat and stat.type == "directory") or adapter == "oil-ssh" then
			require("lazy").load({ plugins = { "oil.nvim" } })
		end
	end
end

return M
