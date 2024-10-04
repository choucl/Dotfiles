local wezterm = require 'wezterm'
local c = {}
if wezterm.config_builder then
  c = wezterm.config_builder()
end

-- window size
c.initial_cols = 96
c.initial_rows = 26
c.window_background_opacity = 1  -- no opacity
c.use_fancy_tab_bar = false

-- close
c.window_close_confirmation = 'NeverPrompt'

c.font = wezterm.font('SF Mono', { weight = 'Regular' })
c.cell_width = 1.00
c.line_height = 1.1
c.front_end = "WebGpu"

-- color
c.color_scheme = 'Catppuccin Mocha'
c.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

c.window_padding = { left = 10, right = 15, top = 10, bottom = 0 }
c.enable_scroll_bar = true
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  c.default_prog = { 'Powershell.exe', '-File', 'C:/ip_ssh.ps1' }

  c.launch_menu = {
    { label = 'ccpc',       args = { 'Powershell.exe', '-File', 'C:/ip_ssh.ps1' }, },
    { label = 'wsl',        args = { 'wsl.exe' }, },
    { label = 'PowerShell', args = { 'C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe' }, },
  }
else
  c.default_prog = { 'zsh' }
  c.launch_menu = {
    { label = 'zsh', args = { 'zsh' }, },
    { label = 'htop', args = { 'htop' }, },
  }
end


c.disable_default_key_bindings = true
local act = wezterm.action
c.keys = {
  { key = 'Tab', mods = 'SHIFT|CTRL', action = act.ActivateTabRelative(1) },
  { key = 'F11', mods = 'NONE', action = act.ToggleFullScreen },
  { key = '+', mods = 'SHIFT|CTRL', action = act.IncreaseFontSize },
  { key = '_', mods = 'SHIFT|CTRL', action = act.DecreaseFontSize },
  { key = 'C', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
  { key = 'N', mods = 'SHIFT|CTRL', action = act.SpawnWindow },
  { key = 'T', mods = 'SHIFT|CTRL', action = act.ShowLauncher },
  { key = 'Enter', mods = 'SHIFT|CTRL', action = act.ShowLauncherArgs { flags = 'FUZZY|TABS|LAUNCH_MENU_ITEMS' } },
  { key = 'V', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },
  { key = 'W', mods = 'SHIFT|CTRL', action = act.CloseCurrentTab{ confirm = false } },
  { key = 'PageUp', mods = 'SHIFT|CTRL', action = act.ScrollByPage(-1) },
  { key = 'PageDown', mods = 'SHIFT|CTRL', action = act.ScrollByPage(1) },
  { key = 'UpArrow', mods = 'SHIFT|CTRL', action = act.ScrollByLine(-1) },
  { key = 'DownArrow', mods = 'SHIFT|CTRL', action = act.ScrollByLine(1) },
}

return c
