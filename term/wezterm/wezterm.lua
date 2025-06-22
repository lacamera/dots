local wezterm = require("wezterm")

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config = {
  font_size = 16.0,
  font = wezterm.font_with_fallback({
    "JetBrains Mono"
  }),
  color_scheme = "vague",
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,
  native_macos_fullscreen_mode = true,
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  }
}

return config
