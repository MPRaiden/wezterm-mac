local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

local root_paths = { os.getenv("HOME") or os.getenv("USERPROFILE") or "/Users/mpr" } -- Dynamic home with fallback
local cached = {}

M.reset_cache_and_toggle = function(window, pane)
	wezterm.log_info("Resetting cache and toggling sessionizer")
	cached = {}
	M.toggle(window, pane)
end

M.toggle = function(window, pane)
	wezterm.log_info("Toggling sessionizer")
	if next(cached) == nil then
		wezterm.log_info("Cache is empty, populating...")
		local home = os.getenv("HOME") or os.getenv("USERPROFILE") or "/Users/mpr"
		if not home then
			wezterm.log_error("No home directory defined")
			return
		end
		table.insert(cached, { label = home, id = "home" }) -- Default home entry
		for _, path in ipairs(root_paths) do
			local expanded_path = path -- No ~ expansion needed
			wezterm.log_info("Searching path: " .. expanded_path)
			local success, stdout, stderr = wezterm.run_child_process({
				"/bin/sh",
				"-c",
				string.format("find %s -mindepth 1 -maxdepth 1 -type d 2>/dev/null", expanded_path),
			})

			if not success then
				wezterm.log_error("find failed: " .. (stderr or "unknown error"))
				return
			end

			wezterm.log_info("find stdout: " .. stdout)
			wezterm.log_info("find stderr: " .. (stderr or "empty"))

			local count = 0
			for line in stdout:gmatch("[^\n]+") do
				wezterm.log_info("Processing line: " .. line)
				if line ~= expanded_path then
					local id = line:gsub(".*/", ""):gsub("%.", "_")
					local label = line
					wezterm.log_info("Adding entry: label=" .. label .. ", id=" .. id)
					table.insert(cached, { label = tostring(label), id = tostring(id) })
					count = count + 1
				end
			end
			wezterm.log_info("Found " .. count .. " directories in " .. expanded_path)
		end
		wezterm.log_info("Final cached entries: " .. wezterm.json_encode(cached))
	else
		wezterm.log_info("Using cached entries: " .. wezterm.json_encode(cached))
	end
	wezterm.log_info("Opening InputSelector with " .. #cached .. " choices")
	window:perform_action(
		act.InputSelector({
			action = wezterm.action_callback(function(win, _, id, label)
				if not id and not label then
					wezterm.log_info("Selection cancelled")
					return
				end
				wezterm.log_info("Selected: label=" .. label .. ", id=" .. id)
				win:perform_action(
					act.SwitchToWorkspace({
						name = id,
						spawn = { cwd = label },
					}),
					pane
				)
			end),
			fuzzy = true,
			title = "Select project",
			choices = cached,
		}),
		pane
	)
end

M.setup = function(config)
	if config.paths then
		root_paths = config.paths
	end
	wezterm.log_info("Sessionizer setup: paths=" .. wezterm.json_encode(root_paths))
end

return M
