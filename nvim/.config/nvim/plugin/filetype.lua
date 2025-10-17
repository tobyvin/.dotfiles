local sudoedit_filename
do
	local filenames
	sudoedit_filename = function(_, bufnr, _)
		if not filenames then
			filenames = {}
			local pid = vim.fn.getpid() --[[@as string]]
			local comm = vim.fn.readfile(("/proc/%s/comm"):format(pid))
			while #comm >= 1 and comm[1] == "nvim" do
				pid = vim.fn.split(vim.fn.readfile(("/proc/%s/stat"):format(pid))[1])[4]
				comm = vim.fn.split(vim.fn.readfile(("/proc/%s/cmdline"):format(pid))[1], "\n")
			end

			local iter = vim.iter(comm)
			local cmd = iter:next()
			if cmd == "sudoedit" or (cmd == "sudo" and iter:next() == "-e") then
				filenames = iter:totable()
			end
		end

		return filenames[bufnr] and vim.filetype.match({ buf = bufnr, filename = filenames[bufnr] }) or nil
	end
end

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
		["nftables.conf"] = "nftables",
		PKGBUILD = "PKGBUILD",
		ethers = "conf",
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
		-- kea configs are json with comments
		[".*/etc/kea/kea-.*%.conf"] = "jsonc",
		-- muttrc xdg base dir
		[".*/mutt/.*%.rc"] = "muttrc",
		-- goimapnotify
		[".*/goimapnotify/.*%.conf"] = "json",
		-- i3blocks
		[".*/i3blocks/config"] = "confini",
		-- conf fallback
		[".*%.conf"] = { "confini", { priority = -math.huge } },
		-- sudoedit/sudo -e match original ft
		["/var/tmp/.*"] = sudoedit_filename,
		[".*"] = {
			function(_, bufnr)
				local content = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""
				if vim.regex([[^#!/usr/bin/env -S cargo +nightly -Zscript]]):match_str(content) ~= nil then
					return "rust"
				end
			end,
			{ priority = -math.huge },
		},
	},
})
