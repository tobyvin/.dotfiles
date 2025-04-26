---@type vim.lsp.Config
return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_dir = function(bufnr, cb)
		local cargo_home = vim.env.CARGO_HOME or vim.fs.joinpath(vim.env.HOME, ".cargo")
		local rust_home = vim.env.RUSTUP_HOME or vim.fs.joinpath(vim.env.HOME, ".rustup")
		local is_lib = vim.iter({
			vim.fs.joinpath(cargo_home, "registry", "src"),
			vim.fs.joinpath(cargo_home, "git", "checkouts"),
			vim.fs.joinpath(rust_home, "toolchains"),
		})
			:map(vim.fs.normalize)
			:any(function(item)
				return vim.startswith(vim.api.nvim_buf_get_name(bufnr), item)
			end)

		local cb_or_default = function(value)
			cb(value or vim.fs.root(bufnr, { "Cargo.toml", "rust-project.json", ".git" }))
		end

		if is_lib then
			local client = vim.iter(vim.lsp.get_clients({ name = "rust_analyzer" })):next()
			cb_or_default(client and client.config.root_dir)
		elseif vim.fn.executable("cargo") == 0 then
			cb_or_default()
		else
			local cmd = { "cargo", "metadata", "--no-deps", "--format-version", "1" }
			vim.system(cmd, { text = true }, function(obj)
				cb_or_default(obj.stdout ~= "" and vim.json.decode(obj.stdout).workspace_root)
			end)
		end
	end,
	settings = {
		["rust-analyzer"] = {
			cargo = {
				features = "all",
				buildScripts = {
					enable = true,
				},
			},
			check = {
				command = "clippy",
			},
			completion = {
				postfix = {
					enable = false,
				},
			},
			imports = {
				granularity = {
					enforce = true,
				},
			},
			procMacro = {
				enable = true,
			},
		},
	},
	capabilities = {
		experimental = {
			serverStatusNotification = true,
			localDocs = true,
		},
	},
	before_init = function(init_params, config)
		-- See https://github.com/rust-lang/rust-analyzer/blob/eb5da56d839ae0a9e9f50774fa3eb78eb0964550/docs/dev/lsp-extensions.md?plain=1#L26
		if config.settings and config.settings["rust-analyzer"] then
			init_params.initializationOptions = config.settings["rust-analyzer"]
		end
	end,
	on_attach = function(client, bufnr)
		local function external_docs()
			local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
			local resp = client:request_sync("experimental/externalDocs", params, nil, bufnr)

			if not resp then
				return false
			end

			if resp.err then
				error(tostring(resp.err))
			end

			if resp.result["local"] then
				---@type string
				local uri = resp.result["local"]:gsub("/[^/]+(/macro%.[^/]+.html)", "%1")
				local cmd = {
					"cargo",
					"+nightly",
					"-Z",
					"unstable-options",
					"config",
					"get",
					"--format=json",
					"build.target",
				}
				local stdout = vim.system(cmd, { text = true }):wait().stdout
				if stdout and stdout ~= "" then
					local target = vim.json.decode(stdout).build.target
					if target then
						uri = uri:gsub("/target/doc/", ("/target/%s/doc/"):format(target))
					end
				end

				local path = uri:gsub("^file://", ""):gsub("%.html#.*$", ".html")
				if vim.uv.fs_stat(path) then
					vim.ui.open(uri)
					return true
				end
			end

			if resp.result.web then
				vim.ui.open(resp.result.web)
				return true
			end

			if type(resp.result) == "string" then
				vim.ui.open(resp.result)
				return true
			end

			return false
		end

		vim.keymap.set({ "x", "n" }, "gx", function()
			return external_docs() and "<Ignore>" or "gx"
		end, {
			expr = true,
			desc = "open external docs",
			buffer = bufnr,
		})

		vim.api.nvim_buf_create_user_command(bufnr, "RustExternalDocs", function()
			return external_docs() or vim.notify("No external docs found", vim.log.levels.WARN, { title = client.name })
		end, {
			desc = "Open external docs",
		})

		vim.api.nvim_buf_create_user_command(bufnr, "RustReload", function()
			vim.notify("Reloading workspace", vim.log.levels.INFO, { title = client.name })
			client:request("rust-analyzer/reloadWorkspace", nil, function(err)
				if err then
					error(tostring(err))
				end
				vim.notify("Workspace reloaded", vim.log.levels.INFO, { title = client.name })
			end, bufnr)
		end, { desc = "Reload rust-analyzer workspace" })
	end,
}
