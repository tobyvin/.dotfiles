vim.filetype.add({
	extension = {
		eml = "mail",
		ron = "ron",
		zsh = "sh",
		service = "systemd",
	},
	filename = {
		PKGBUILD = "PKGBUILD",
		tridactylrc = "trytactylrc",
	},
	pattern = {
		-- fontconfig
		[".*/fontconfig/fonts%.conf"] = "xml",
		[".*/fontconfig/conf%.d/.*%.conf"] = "xml",
		[".*/usr/share/fontconfig/fonts%.conf"] = "xml",
		[".*/usr/share/fontconfig/conf%..*/.*%.conf"] = "xml",
		-- sway drop-ins
		[".*/sway/config%.d/.*%.conf"] = "swayconfig",
		[".*/%.sway/config%.d/.*%.conf"] = "swayconfig",
		-- systemd-networkd
		[".*/etc/systemd/network/.*%.d/.*%.conf"] = "systemd",
		[".*/etc/systemd/network/.*%.d/%.#.*"] = "systemd",
		[".*/etc/systemd/network/%.#.*"] = "systemd",
		-- muttrc xdg base dir
		[".*/mutt/.*%.rc"] = "muttrc",
		-- conf fallback
		[".*%.conf"] = { "confini", { priority = -math.huge } },
		-- sudoedit/sudo -e match original ft
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
