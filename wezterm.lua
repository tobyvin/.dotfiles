local wezterm = require "wezterm"

return {
    default_prog = {"wsl.exe"},
    font = wezterm.font_with_fallback({"Fira Code", "FiraCode NF"}),
    window_close_confirmation = "NeverPrompt",
    canonicalize_pasted_newlines = true,
    audible_bell = "Disabled",
    visual_bell = {
        fade_in_duration_ms = 75,
        fade_out_duration_ms = 75,
        target = "CursorColor"
    },
    exit_behavior = "Close",
    use_fancy_tab_bar = false,
    enable_tab_bar = false,
    enable_scroll_bar = true
}
