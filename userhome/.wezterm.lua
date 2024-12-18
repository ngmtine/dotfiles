local wezterm = require 'wezterm';
local config = wezterm.config_builder()

-- font
config.font = wezterm.font("HackGen Console NF", { weight = "Regular", stretch = "Normal", style = "Normal" })
config.font_size = 14.0

-- theme
config.color_scheme = 'iceberg-dark'
config.window_background_opacity = 0.95
config.window_decorations = "RESIZE"       -- ウィンドウ最上部のバー非表示
config.hide_tab_bar_if_only_one_tab = true -- タブ1つのときはタブ非表示

return config
