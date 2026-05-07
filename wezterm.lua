local wezterm = require("wezterm")
local act = wezterm.action

local leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

local config = {
	leader = leader,
	keys = {
		{ key = "t", mods = "CTRL", action = act.SpawnTab("CurrentPaneDomain") },
		{ key = "]", mods = "CTRL", action = act.ActivateTabRelative(1) },
		{ key = "[", mods = "CTRL", action = act.ActivateTabRelative(-1) },
		{ key = "q", mods = "CTRL", action = act.CloseCurrentTab({ confirm = false }) },
		{ key = "x", mods = "LEADER", action = act.ActivateCopyMode },
	},
	color_scheme = "Tokyo Night Day",
	automatically_reload_config = true,
	window_close_confirmation = "NeverPrompt",
	clean_exit_codes = { 0, 1, 130 },
	default_cursor_style = "BlinkingBlock",
	adjust_window_size_when_changing_font_size = false,
	check_for_updates = true,
	font_size = 14,
	font = wezterm.font("JetBrains Mono", { weight = "Medium" }),
	window_decorations = "RESIZE|INTEGRATED_BUTTONS",
	enable_tab_bar = true,
	use_fancy_tab_bar = false,
	tab_max_width = 50,
	scrollback_lines = 10000000,
	default_workspace = "main",
	harfbuzz_features = { "-calt", "-liga", "-dlig" },
	max_fps = 120,
	window_padding = {
		left = 10,
		right = 10,
		top = 30,
		bottom = 10,
	},
	colors = {
		tab_bar = {
			background = "#e1e2e7", -- base background (light grey-blue)
			active_tab = {
				bg_color = "#ffffff", -- active tab (clean white)
				fg_color = "#3760bf", -- blue accent (Tokyo Night primary)
				intensity = "Bold",
			},
			inactive_tab = {
				bg_color = "#e1e2e7",
				fg_color = "#565a6e", -- muted grey text
			},
			new_tab = {
				bg_color = "#e1e2e7",
				fg_color = "#565a6e",
			},
		},
	},
}

return config
