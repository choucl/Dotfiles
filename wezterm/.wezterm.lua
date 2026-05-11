local wezterm = require("wezterm")
local c = {}
if wezterm.config_builder then
	c = wezterm.config_builder()
end
print(package.path)

local function pad_tab_title(title, width)
	local truncated = wezterm.truncate_right(title, width)
	local padding = math.max(0, width - wezterm.column_width(truncated))
	return truncated .. string.rep(" ", padding)
end

local function ssh_reachable(host, port)
	local success, stdout, stderr = wezterm.run_child_process({
		"ssh",
		"-o",
		"ConnectTimeout=1",
		"-p",
		tostring(port),
		host,
		"exit",
	})
	print(success, stdout, stderr)
	return success
end

-- window size
c.initial_cols = 96
c.initial_rows = 26
c.window_background_opacity = 1 -- no opacity
c.use_fancy_tab_bar = true
c.font_size = 14
c.window_frame = {
	font = wezterm.font("SF Pro"),
	font_size = 14.0,
	active_titlebar_bg = "#313244",
	inactive_titlebar_bg = "#1e1e2e",
	active_titlebar_fg = "#cdd6f4",
	inactive_titlebar_fg = "#a6adc8",
	button_fg = "#bac2de",
	button_bg = "#313244",
	button_hover_fg = "#cdd6f4",
	button_hover_bg = "#45475a",
}

c.window_close_confirmation = "NeverPrompt"

c.font = wezterm.font("SF Mono", { weight = "Regular" })
c.cell_width = 1.00
c.line_height = 1.1
c.front_end = "WebGpu"

-- color
c.color_scheme = "Catppuccin Mocha"
c.colors = {
	tab_bar = {
		inactive_tab_edge = "#6c7086",
		background = "#1e1e2e",
		active_tab = {
			bg_color = "#45475a",
			fg_color = "#cdd6f4",
		},
		inactive_tab = {
			bg_color = "#313244",
			fg_color = "#bac2de",
		},
		inactive_tab_hover = {
			bg_color = "#585b70",
			fg_color = "#cdd6f4",
		},
		new_tab = {
			bg_color = "#313244",
			fg_color = "#cdd6f4",
		},
		new_tab_hover = {
			bg_color = "#585b70",
			fg_color = "#cdd6f4",
		},
	},
}

c.tab_bar_style = {
	new_tab = wezterm.format({
		{ Text = " + " },
	}),
	new_tab_hover = wezterm.format({
		{ Text = " + " },
	}),
}
c.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

c.window_padding = { left = 10, right = 15, top = 10, bottom = 0 }
c.enable_scroll_bar = true

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab.active_pane.title
	if title == nil or title == "" then
		title = "Tab " .. (tab.tab_index + 1)
	end

	return {
		{ Text = " " .. pad_tab_title(title, math.max(1, max_width - 2)) .. " " },
	}
end)

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	local postfix
	if ssh_reachable("choucl@192.168.164.116", 22) then
		postfix = "lan"
	else
		postfix = "portal"
	end
	c.default_domain = "SSH:ccpc-" .. postfix
	c.launch_menu = {
		{ label = "ccpc", domain = { DomainName = "SSH:ccpc-" .. postfix } },
		{ label = "wsl", args = { "wsl.exe" } },
	}
else
	c.default_prog = { "zsh" }
	c.launch_menu = {
		{ label = "zsh", args = { "zsh" } },
		{ label = "htop", args = { "htop" } },
	}
end

c.disable_default_key_bindings = true
local act = wezterm.action
c.keys = {
	{ key = "L", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(1) },
	{ key = "H", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },
	{ key = "F11", mods = "NONE", action = act.ToggleFullScreen },
	{ key = "+", mods = "SHIFT|CTRL", action = act.IncreaseFontSize },
	{ key = "_", mods = "SHIFT|CTRL", action = act.DecreaseFontSize },
	{ key = "c", mods = "CMD", action = act.CopyTo("Clipboard") },
	{ key = "N", mods = "SHIFT|CTRL", action = act.SpawnWindow },
	{ key = "T", mods = "SHIFT|CTRL", action = act.ShowLauncher },
	{ key = "t", mods = "CMD", action = act.ShowLauncher },
	{ key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") },
	{ key = "W", mods = "SHIFT|CTRL", action = act.CloseCurrentTab({ confirm = false }) },
	{ key = "w", mods = "CMD", action = act.CloseCurrentTab({ confirm = false }) },
	{ key = "PageUp", mods = "SHIFT|CTRL", action = act.ScrollByPage(-1) },
	{ key = "PageDown", mods = "SHIFT|CTRL", action = act.ScrollByPage(1) },
	{ key = "UpArrow", mods = "SHIFT|CTRL", action = act.ScrollByLine(-1) },
	{ key = "DownArrow", mods = "SHIFT|CTRL", action = act.ScrollByLine(1) },
	{
		key = "Enter",
		mods = "SHIFT|CTRL",
		action = act.ShowLauncherArgs({ flags = "FUZZY|TABS|LAUNCH_MENU_ITEMS" }),
	},
}

return c
