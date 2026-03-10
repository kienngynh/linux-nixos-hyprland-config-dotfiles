local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'Catppuccin Macchiato'
config.font = wezterm.font('JetBrains Mono')
config.font_size = 12.0

-- Minimalist UI
config.window_decorations = "RESIZE"
config.enable_tab_bar = false
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.warn_about_missing_glyphs = false

return config
