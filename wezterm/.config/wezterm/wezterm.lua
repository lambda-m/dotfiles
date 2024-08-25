-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Nord (Gogh)'

config.font = wezterm.font("Inconsolata")
config.font_size = 28


config.keys = {
  {
    key = 'C',
    mods = 'CTRL',
    action = wezterm.action.CopyTo 'ClipboardAndPrimarySelection',
  },
    { key = '-', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment },
    { key = '0', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment },
    { key = '1', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment },
    { key = '2', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment },
    { key = '3', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment },
    { key = '4', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment },
    { key = '5', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment },
    { key = '6', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment },
    { key = '7', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment },
    { key = '8', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment },
    { key = '9', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment },
    { key = '=', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment },
    { key = '[', mods = 'SHIFT|SUPER', action = wezterm.action.DisableDefaultAssignment },
    { key = ']', mods = 'SHIFT|SUPER', action = wezterm.action.DisableDefaultAssignment },
    { key = 'c', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment },
    { key = 'f', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment },
    { key = 'k', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment },
    { key = 'm', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment },
    { key = 'n', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment },
    { key = 'r', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment },
    { key = 't', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment },
    { key = 'v', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment },
    { key = 'w', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment },
    { key = '{', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment },
    { key = '{', mods = 'SHIFT|SUPER', action = wezterm.action.DisableDefaultAssignment },
    { key = '}', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment },
    { key = '}', mods = 'SHIFT|SUPER', action = wezterm.action.DisableDefaultAssignment },
}

-- and finally, return the configuration to wezterm
return config