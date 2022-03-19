local lsp_status = require 'lsp-status'
lsp_status.status()
lsp_status.register_progress()
lsp_status.config({
    indicator_errors = "",
    indicator_warnings = "",
    indicator_info = "",
    indicator_hint = "",
    indicator_ok = "",
    current_function = true,
    update_interval = 100,
    status_symbol = ' 🇻',
})