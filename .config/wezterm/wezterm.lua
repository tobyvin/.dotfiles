local wezterm = require("wezterm")

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	local is_win = true
end

local config = {
	default_prog = {
		"/usr/bin/zsh",
		"-l",
		"-c",
		"tmux new -As home",
	},

	enable_tab_bar = false,
	color_scheme = "Gruvbox dark, hard (base16)",
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},

	window_background_opacity = 0.9,
	font = wezterm.font_with_fallback({ "FiraCode Nerd Font", "FireCodeNF" }),
	font_size = 11,

	-- disable_default_key_bindings = true,
	keys = {
		{ key = "-", mods = "CTRL", action = "DecreaseFontSize" },
		{ key = "=", mods = "CTRL", action = "IncreaseFontSize" },
	},

	alternate_buffer_wheel_scroll_speed = 1,
}

return config
