
local wezterm = require 'wezterm';
return {
    ssh_domains = {
        {
        -- This name identifies the domain
        name = "odin",
        -- The address to connect to
        remote_address = "tobyvin.com:2222",
        -- The username to use on the remote host
        username = "tobyv",
        }
    },
    default_prog = {"wsl.exe"},
    color_scheme = "Dark+",
    font = wezterm.font("FiraCode NF"),
    font_size = 11.0,
    harfbuzz_features = {"zero"},
    window_background_opacity = 0.95,
    use_dead_keys = false,
    window_close_confirmation = "NeverPrompt",
    initial_cols = 120,
    initial_rows = 30,
    hide_tab_bar_if_only_one_tab = true
}