local wezterm = require("wezterm")
local act = wezterm.action

-- Using the config builder API
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.enable_wayland = true

-- Fonts
config.font = wezterm.font("0xProto")
config.font_size = 11.6
config.cell_width = 0.9  -- Reduce el espaciado entre caracteres

-- Tab bar font
config.window_frame = {
	font_size = 9.0,
}

-- Window
-- config.window_background_opacity = 0.85
config.window_decorations = "NONE"
config.window_close_confirmation = "AlwaysPrompt"
config.default_workspace = "main"
config.use_fancy_tab_bar = false
config.status_update_interval = 2000
config.tab_bar_at_bottom = false
-- config.enable_scroll_bar = true

-- Background image
config.window_background_image = "/home/osgomez/.config/wezterm/wallpapers/monokai-monokai-pro-city.png"
config.window_background_image_hsb = {
	-- Darken the background image by reducing it to 1/3rd
	brightness = 0.1,

	-- You can adjust the hue by scaling its value.
	-- a multiplier of 1.0 leaves the value unchanged.
	hue = 1.0,

	-- You can adjust the saturation also.
	saturation = 1.0,
}

-- Color
package.path = package.path .. ";/home/osgomez/.config/wezterm/themes/?.lua"
local monokai_octagon = require("monokai-octagon")
config.colors = monokai_octagon.colors

-- Spacing
config.initial_cols = 103
config.initial_rows = 27

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- External multiplexer
-- config.default_prog = { "zellij", "-l", "compact" }

-- Panes
config.inactive_pane_hsb = {
	saturation = 0.95,
	brightness = 0.8,
}

-- Keys
config.leader = { key = "g", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
	-- Pane keybindings
	{ key = "s", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "q", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "o", mods = "LEADER", action = act.RotatePanes("Clockwise") },
	{ key = "LeftArrow", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "RightArrow", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "UpArrow", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "DownArrow", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "Backspace", mods = "CTRL", action = act.SendKey({ key = "w", mods = "CTRL" }) },
	-- We can make separate keybindings for resizing panes
	-- But Wezterm offers custom "mode" in the name of "KeyTable"
	{
		key = "r",
		mods = "LEADER",
		action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }),
	},

	-- Tab keybindings
	{ key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "n", mods = "LEADER", action = act.ShowTabNavigator },
	{
		key = "e",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Renaming Tab Title...:" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	-- Key table for moving tabs around
	{ key = "m", mods = "LEADER", action = act.ActivateKeyTable({ name = "move_tab", one_shot = false }) },
	-- Or shortcuts to move tab w/o move_tab table. SHIFT is for when caps lock is on
	{ key = "{", mods = "LEADER|SHIFT", action = act.MoveTabRelative(-1) },
	{ key = "}", mods = "LEADER|SHIFT", action = act.MoveTabRelative(1) },

	-- Lastly, workspace
	{ key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
}
-- I can use the tab navigator (LDR t), but I also want to quickly navigate tabs with index
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
end

config.key_tables = {
	resize_pane = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
	move_tab = {
		{ key = "h", action = act.MoveTabRelative(-1) },
		{ key = "j", action = act.MoveTabRelative(-1) },
		{ key = "k", action = act.MoveTabRelative(1) },
		{ key = "l", action = act.MoveTabRelative(1) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
}

-- local function separate(left, separator, right)
-- 	local ret = ""
--
-- 	if left then
-- 		ret = left .. separator
-- 	end
--
-- 	if right then
-- 		ret = ret .. right
-- 	end
--
-- 	return ret
-- end

-- Module to show the battery
local function get_battery_icon()
	local bat = ""
	-- local state = ""

	for _, b in ipairs(wezterm.battery_info()) do
		bat = string.format("%.0f", b.state_of_charge * 100)
		-- state = b.state
	end

	local bat_status = math.ceil(tonumber(bat) / 100 * 5)

	local battery_icons = {
		[1] = wezterm.nerdfonts.fa_battery_empty,
		[2] = wezterm.nerdfonts.fa_battery_quarter,
		[3] = wezterm.nerdfonts.fa_battery_half,
		[4] = wezterm.nerdfonts.fa_battery_three_quarters,
		[5] = wezterm.nerdfonts.fa_battery_full,
	}

	local icon = battery_icons[bat_status] or wezterm.nerdfonts.fa_battery_empty

	-- if state == "Charging" then
	-- 	icon = wezterm.format({ { Foreground = { Color = "green" } }, icon })
	-- end

	return icon, bat
end

-- Tab bar
wezterm.on("update-status", function(window, pane)
	-- Separator
	local separator = "|"

	-- Workspace name
	local stat = window:active_workspace()
	local stat_color = "#f7768e"

	-- It's a little silly to have workspace name all the time
	-- Utilize this to display LDR or current key table name
	if window:active_key_table() then
		stat = window:active_key_table()
		stat_color = "#7dcfff"
	end
	if window:leader_is_active() then
		stat = "LDR"
		stat_color = "#bb9af7"
	end

	local basename = function(s)
		-- Nothing a little regex can't fix
		return string.gsub(s, "(.*[/\\])(.*)", "%2")
	end

	-- Current command
	local cmd = pane:get_foreground_process_name()
	-- CWD and CMD could be nil (e.g. viewing log using Ctrl-Alt-l)
	cmd = cmd and basename(cmd) or ""

	-- Time
	local time = wezterm.strftime("%H:%M")

	-- Left status (left of the tab line)
	window:set_left_status(wezterm.format({
		{ Foreground = { Color = stat_color } },
		{ Text = "  " },
		{ Text = wezterm.nerdfonts.oct_table .. "  " .. stat },
		{ Text = " " .. separator },
	}))

	local battery_icon, battery = get_battery_icon()

	-- Right status
	window:set_right_status(wezterm.format({
		-- Wezterm has a built-in nerd fonts
		-- https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html
		{ Text = battery_icon .. " " .. battery .. "%" },
		{ Text = " " .. separator .. " " },
		{ Foreground = { Color = "#e0af68" } },
		{ Text = wezterm.nerdfonts.cod_terminal_linux .. "  " .. cmd },
		"ResetAttributes",
		{ Text = " " .. separator .. " " },
		{ Text = wezterm.nerdfonts.md_clock .. "  " .. time },
		{ Text = "  " },
	}))
end)

-- Change mouse scroll amount
config.mouse_bindings = {
	{
		event = { Down = { streak = 1, button = { WheelUp = 1 } } },
		mods = "NONE",
		action = act.ScrollByLine(-2),
	},
	{
		event = { Down = { streak = 1, button = { WheelDown = 1 } } },
		mods = "NONE",
		action = act.ScrollByLine(2),
	},
}

-- Start window with initial size (no maximize)
wezterm.on("gui-startup", function(cmd)
	local _, _, window = wezterm.mux.spawn_window(cmd or {})
end)

return config
