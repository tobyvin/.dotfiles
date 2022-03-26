local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
	return
end

local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting

null_ls.setup({
  sources = {
    -- Code Actions
    code_actions.gitsigns,
    -- code_actions.shellcheck,

    -- Diagnostics
    -- diagnostics.codespell,
		-- diagnostics.luacheck,
		-- diagnostics.markdownlint,
		-- diagnostics.shellcheck,

    -- Formatting
    formatting.prettier,
    formatting.black,
    formatting.latexindent,
    formatting.markdownlint,
    formatting.stylua,
    formatting.rustfmt.with({
        extra_args = function(params)
            local Path = require("plenary.path")
            local cargo_toml = Path:new(params.root .. "/" .. "Cargo.toml")

            if cargo_toml:exists() and cargo_toml:is_file() then
                for _, line in ipairs(cargo_toml:readlines()) do
                    local edition = line:match([[^edition%s*=%s*%"(%d+)%"]])
                    if edition then
                        return { "--edition=" .. edition }
                    end
                end
            end
            -- default edition when we don't find `Cargo.toml` or the `edition` in it.
            return { "--edition=2021" }
        end,
    }),
    formatting.shfmt,
  },
})
