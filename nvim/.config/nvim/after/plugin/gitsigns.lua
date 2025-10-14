local success, gitsigns = pcall(require, "gitsigns")
if not success then
	return
end

local function with_opfunc(fn)
	return function()
		local _opfunc = vim.go.operatorfunc
		---@diagnostic disable-next-line: duplicate-set-field
		_G._opfunc = function()
			fn({
				vim.api.nvim_buf_get_mark(0, "[")[1],
				vim.api.nvim_buf_get_mark(0, "]")[1],
			})
			vim.go.operatorfunc = _opfunc
			_G._opfunc = nil
		end
		vim.go.operatorfunc = "v:lua._opfunc"
		return "g@"
	end
end

gitsigns.setup({
	signs = {
		add = { text = "▎" },
		change = { text = "▎" },
		delete = { text = "󰐊" },
		topdelete = { text = "󰐊" },
		changedelete = { text = "▎" },
	},
	on_attach = function(bufnr)
		vim.keymap.set("n", "]c", function()
			if vim.wo.diff then
				return "]c"
			else
				return [[<Cmd>lua require("gitsigns").nav_hunk("next")<CR>]]
			end
		end, { expr = true, desc = "next hunk", buffer = bufnr })

		vim.keymap.set("n", "[c", function()
			if vim.wo.diff then
				return "[c"
			else
				return [[<Cmd>lua require("gitsigns").nav_hunk("prev")<CR>]]
			end
		end, {
			expr = true,
			desc = "previous hunk",
			buffer = bufnr,
		})

		vim.keymap.set("n", "<leader>gr", with_opfunc(require("gitsigns").reset_hunk), {
			desc = "reset hunk",
			buffer = bufnr,
			expr = true,
		})

		vim.keymap.set("n", "<leader>grr", require("gitsigns").reset_hunk, {
			desc = "reset hunk",
			buffer = bufnr,
		})

		vim.keymap.set("v", "<leader>gr", function()
			require("gitsigns").reset_hunk({ vim.fn.getpos(".")[2], vim.fn.getpos("v")[2] })
		end, {
			desc = "reset hunk",
			buffer = bufnr,
		})

		vim.keymap.set("n", "<leader>gs", with_opfunc(require("gitsigns").stage_hunk), {
			desc = "stage hunk",
			buffer = bufnr,
			expr = true,
		})

		vim.keymap.set("n", "<leader>gss", require("gitsigns").stage_hunk, {
			desc = "stage hunk",
			buffer = bufnr,
		})

		vim.keymap.set("v", "<leader>gs", function()
			require("gitsigns").stage_hunk({ vim.fn.getpos(".")[2], vim.fn.getpos("v")[2] })
		end, {
			desc = "stage hunk",
			buffer = bufnr,
		})
	end,
})
