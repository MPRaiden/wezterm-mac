local wezterm = require("wezterm")
local config = {}
local act = wezterm.action

-- Adjust Lua module path to include home directory for sessionizer.lua
package.path = package.path .. ";" .. os.getenv("HOME") .. "/?.lua"

-- Load the sessionizer module
local sessionizer = require("sessionizer")

-- Configure the sessionizer
sessionizer.setup({
	paths = {
		os.getenv("HOME"),
		os.getenv("HOME") .. "/Documents", -- Add specific paths if needed
		os.getenv("HOME") .. "/Projects",
	},
})

config = {
	color_scheme = "rose-pine",
	automatically_reload_config = true,
	window_close_confirmation = "NeverPrompt", -- No prompts for closing windows/tabs
	default_cursor_style = "BlinkingBlock",
	adjust_window_size_when_changing_font_size = false,
	font_size = 14,
	font = wezterm.font("JetBrains Mono"),
	enable_tab_bar = false,
	use_fancy_tab_bar = false,
	--window_background_opacity = 0.9,
	macos_window_background_blur = 20,
	window_decorations = "RESIZE",
	scrollback_lines = 10000,
	default_workspace = "main",
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
	max_fps = 120,
	window_padding = {
		left = 15,
		right = 15,
		top = 15,
		bottom = 0,
	},
	font_rules = {
		{
			italic = true,
			font = wezterm.font("JetBrains Mono", { italic = false }),
		},
	},
	colors = {
		background = "black",
		cursor_bg = "#FFFFFF",
		cursor_fg = "#000000",
		cursor_border = "#FFFFFF",
	},
	leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 },
	keys = {
		{ key = "a", mods = "LEADER|CTRL", action = act.SendKey({ key = "a", mods = "CTRL" }) },
		{ key = "c", mods = "LEADER", action = act.ActivateCopyMode },
		{ key = "phys:Space", mods = "LEADER", action = act.ActivateCommandPalette },
		{ key = "[", mods = "CTRL", action = act.SwitchWorkspaceRelative(-1) },
		{ key = "]", mods = "CTRL", action = act.SwitchWorkspaceRelative(1) },
		{ key = "s", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) }, -- Workspace switcher
		{ key = "q", mods = "LEADER", action = act.CloseCurrentPane({ confirm = false }) },
		{
			key = "f",
			mods = "LEADER",
			action = wezterm.action_callback(function(window, pane)
				sessionizer.toggle(window, pane)
			end),
		},
	},
}

return config
