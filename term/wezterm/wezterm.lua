local wezterm = require("wezterm")
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.colors = {}
config.colors.background = "#111111"
config.font = wezterm.font_with_fallback({ "JetBrains Mono" })
config.tab_bar_at_bottom = true
config.freetype_load_target = "HorizontalLcd"
config.use_fancy_tab_bar = false
config.enable_scroll_bar = false
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

return config
