vim.filetype.add({
	extension = {
		eml = "mail",
		jinja = "jinja",
		jinja2 = "jinja",
		j2 = "jinja",
		nft = "nftables",
		ron = "ron",
		service = "systemd",
		PKGBUILD = "PKGBUILD",
		gcode = "gcode",
	},
	filename = {
		tridactylrc = "trytactylrc",
		["nftables.conf"] = "nftables",
		PKGBUILD = "PKGBUILD",
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
		-- goimapnotify
		[".*/goimapnotify/.*%.conf"] = "json",
		-- i3blocks
		[".*/i3blocks/config"] = "confini",
		-- conf fallback
		[".*%.conf"] = { "confini", { priority = -math.huge } },
		-- sudoedit/sudo -e match original ft
		["/var/tmp/.*"] = function(_, bufnr, _)
			local pid = vim.fn.getpid()
			local comm = vim.fn.readfile(("/proc/%s/comm"):format(pid))

			while #comm >= 1 and comm[1] == "nvim" do
				---@diagnostic disable-next-line: cast-local-type
				pid = vim.fn.split(vim.fn.readfile(("/proc/%s/stat"):format(pid))[1])[4]
				comm = vim.fn.split(vim.fn.readfile(("/proc/%s/cmdline"):format(pid))[1], "\n")

				if #comm >= 1 and comm[1] == "sudoedit" or (#comm >= 2 and comm[1] == "sudo" and comm[2] == "-e") then
					return vim.filetype.match({ buf = bufnr, filename = comm[#comm] })
				end
			end

			return vim.filetype.match({ buf = bufnr })
		end,
	},
})
