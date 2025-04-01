local function buf_build(client, bufnr)
	local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
	client.request("textDocument/build", params, function(err, result)
		if err then
			return vim.notify(err.code .. ": " .. err.message, vim.log.levels.ERROR)
		end
		local texlab_build_status = {
			[0] = "Success",
			[1] = "Error",
			[2] = "Failure",
			[3] = "Cancelled",
		}
		vim.notify("Build " .. texlab_build_status[result.status], vim.log.levels.INFO)
	end, bufnr)
end

local function buf_search(client, bufnr)
	local params = vim.lsp.util.make_position_params(nil, client.offset_encoding)
	client.request("textDocument/forwardSearch", params, function(err, result)
		if err then
			return vim.notify(err.code .. ": " .. err.message, vim.log.levels.ERROR)
		end
		local texlab_forward_status = {
			[0] = "Success",
			[1] = "Error",
			[2] = "Failure",
			[3] = "Unconfigured",
		}
		vim.notify("Search " .. texlab_forward_status[result.status], vim.log.levels.INFO)
	end, bufnr)
end

local function buf_cancel_build(client, bufnr)
	client:exec_cmd({
		title = "cancel",
		command = "texlab.cancelBuild",
	}, { bufnr = bufnr })
end

local function dependency_graph(client, bufnr)
	client:exec_cmd({
		command = "texlab.showDependencyGraph",
	}, function(err, result)
		if err then
			return vim.notify(err.code .. ": " .. err.message, vim.log.levels.ERROR)
		end
		vim.notify("The dependency graph has been generated:\n" .. result, vim.log.levels.INFO)
	end, { bufnr = bufnr })
end

local function clean_artifacts(client, bufnr)
	client:exec_cmd({
		title = "cleanArtifacts",
		command = "texlab.cleanArtifacts",
		arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
	}, { bufnr = bufnr }, function(err, _)
		if err then
			return vim.notify(err.code .. ": " .. err.message, vim.log.levels.ERROR)
		end
		vim.notify("Cleaned artifacts files", vim.log.levels.INFO)
	end)
end

local function clean_auxiliary(client, bufnr)
	client:exec_cmd({
		title = "cleanAuxiliary",
		command = "texlab.cleanAuxiliary",
		arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
	}, { bufnr = bufnr }, function(err, _)
		if err then
			return vim.notify(err.code .. ": " .. err.message, vim.log.levels.ERROR)
		end
		vim.notify("Cleaned auxiliary files", vim.log.levels.INFO)
	end)
end

local function buf_find_envs(client, bufnr)
	client:exec_cmd({
		title = "findEnvironments",
		command = "texlab.findEnvironments",
		arguments = {
			vim.lsp.util.make_position_params(vim.api.nvim_get_current_win(), client.offset_encoding),
		},
	}, { bufnr = bufnr }, function(err, result)
		if err then
			return vim.notify(err.code .. ": " .. err.message, vim.log.levels.ERROR)
		end
		local env_names = vim.iter(ipairs(result))
			:map(function(index, env)
				return (" "):rep(index - 1) .. env.name.text
			end)
			:totable()

		vim.lsp.util.open_floating_preview(env_names, "", {
			height = math.max(1, #env_names),
			width = vim.iter(env_names):map(string.len):fold(("Environments"):len(), math.max),
			focusable = false,
			focus = false,
			border = vim.o.winborder,
			title = "Environments",
		})
	end)
end

local function buf_change_env(client, bufnr)
	local pos = vim.api.nvim_win_get_cursor(0)
	local uri = vim.uri_from_bufnr(bufnr)
	vim.ui.input({ prompt = "Environment name" }, function(input)
		if not input then
			return vim.notify("No environment name provided", vim.log.levels.WARN)
		end
		client:exec_cmd({
			title = "changeEnvironment",
			command = "texlab.changeEnvironment",
			arguments = {
				{
					textDocument = { uri = uri },
					position = { line = pos[1] - 1, character = pos[2] },
					newName = input,
				},
			},
		}, { bufnr = bufnr })
	end)
end

---@type vim.lsp.Config
return {
	cmd = { "texlab" },
	filetypes = { "tex", "plaintex", "bib" },
	root_markers = {
		".git",
		".latexmkrc",
		".texlabroot",
		"texlabroot",
		"Tectonic.toml",
	},
	settings = {
		texlab = {
			rootDirectory = nil,
			build = {
				executable = "latexmk",
				args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
				onSave = true,
				forwardSearchAfter = true,
			},
			forwardSearch = {
				executable = "zathura",
				args = {
					"--synctex-editor-command",
					[[nvim-texlabconfig -file '%%%{input}' -line %%%{line} -server ]] .. vim.v.servername,
					"--synctex-forward",
					"%l:1:%f",
					"%p",
				},
			},
			chktex = {
				onOpenAndSave = true,
				onEdit = true,
			},
			diagnosticsDelay = 300,
			latexFormatter = "latexindent",
			latexindent = {
				["local"] = vim.fs.joinpath(vim.env.XDG_CONFIG_HOME, "latexindent/indentconfig.yaml"),
				modifyLineBreaks = true,
			},
			bibtexFormatter = "texlab",
			formatterLineLength = 80,
		},
	},
	on_attach = function(client, bufnr)
		local winid = vim.api.nvim_get_current_win()
		vim.b[bufnr].tex_flavor = "latex"
		vim.wo[winid][0].spell = true

		vim.iter({
			{ "TexlabBuild", buf_build, { desc = "Build the current buffer" } },
			{ "TexlabForward", buf_search, { desc = "Forward search from current position" } },
			{ "TexlabCancelBuild", buf_cancel_build, { desc = "Cancel the current build" } },
			{ "TexlabDependencyGraph", dependency_graph, { desc = "Show the dependency graph" } },
			{ "TexlabCleanArtifacts", clean_artifacts, { desc = "Clean the artifacts" } },
			{ "TexlabCleanAuxiliary", clean_auxiliary, { desc = "Clean the auxiliary files" } },
			{ "TexlabFindEnvironments", buf_find_envs, { desc = "Find the environments at current position" } },
			{ "TexlabChangeEnvironment", buf_change_env, { desc = "Change the environment at current position" } },
		}):each(function(args)
			vim.api.nvim_buf_create_user_command(bufnr, args[1], function()
				args[2](client, bufnr)
			end, args[3])
		end)
	end,
}
