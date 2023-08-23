vim.filetype.add({
	extension = {
		eml = "mail",
		ron = "ron",
		zsh = "sh",
	},
	filename = {
		["PKGBUILD"] = "PKGBUILD",
	},
	pattern = {
		[".*/sway/config.d/.*%.conf"] = "swayconfig",
		[".*/mutt/.*%.rc"] = "muttrc",
		[".*%.conf"] = { "confini", { priority = -math.huge } },
		["/var/tmp/.*"] = function(_, bufnr, _)
			local pid = vim.fn.getpid()
			local cl = vim.fn.readfile(("/proc/%s/comm"):format(pid))

			while #cl >= 1 and cl[1] == "nvim" do
				pid = vim.fn.split(vim.fn.readfile(("/proc/%s/stat"):format(pid))[1])[4]
				cl = vim.fn.split(vim.fn.readfile(("/proc/%s/cmdline"):format(pid))[1], "\n")

				if #cl >= 1 and cl[1] == "sudoedit" or (#cl >= 2 and cl[1] == "sudo" and cl[2] == "-e") then
					return vim.filetype.match({ buf = bufnr, filename = cl[#cl] })
				end
			end

			return vim.filetype.match({ buf = bufnr })
		end,
	},
})
