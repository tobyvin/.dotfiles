local M = {
	"TimUntersberger/neogit",
	dependencies = { "sindrets/diffview.nvim" },
}

function M.init()
	vim.keymap.set("n", "<leader>gg", function()
		require("neogit").open()
	end, { desc = "neogit" })
end

function M.config()
	-- TODO: revert once pr is merged
	--
	-- Refs: #415
	local Buffer = require("neogit.lib.buffer")
	local config = require("neogit.config")
	local input = require("neogit.lib.input")

	local CommitEditor = require("neogit.buffers.commit_editor")
	function CommitEditor:open()
		local written = false
		self.buffer = Buffer.create({
			name = self.filename,
			filetype = "gitcommit",
			buftype = "",
			kind = config.values.commit_popup.kind,
			modifiable = true,
			readonly = false,
			autocmds = {
				["BufWritePost"] = function()
					written = true
				end,
				["BufUnload"] = function()
					if written then
						if
							config.values.disable_commit_confirmation
							or input.get_confirmation("Are you sure you want to commit?")
						then
							vim.cmd("silent g/^#/d | silent w!")
						end
					end
					if self.on_unload then
						self.on_unload(written)
					end
					require("neogit.process").defer_show_preview_buffers()
				end,
			},
			mappings = {
				n = {
					["q"] = function(buffer)
						buffer:close(true)
					end,
				},
			},
			initialize = function(buffer)
				buffer:set_lines(0, -1, false, self.content)
				if not config.values.disable_insert_on_commit then
					vim.cmd(":startinsert")
				end
				-- NOTE: This avoids the user having to force to save the contents of the buffer.
				vim.cmd("silent w!")
			end,
		})
	end

	require("neogit").setup({
		disable_commit_confirmation = true,
		disable_signs = true,
		integrations = {
			diffview = true,
		},
	})
end

return M
