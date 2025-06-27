local wezterm = require("wezterm")

wezterm.on('format-tab-title', function(tab)
  local pane = tab.active_pane
  local proc = pane.foreground_process_name or ''
  local cmd = proc:gsub('.*[\\/]', '')

  if cmd == '' then
    cmd = pane.title or 'sh'
  end

  local label = string.format('%d: %s',
    tab.tab_index, cmd)

  return {{ Text = ' ' .. label .. ' ' }}
end)

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

config = {
  font_size = 16.0,
  font = wezterm.font({
    family = "JetBrains Mono",
    -- disable ligatures
    harfbuzz_features = {
      'calt=0', 'clig=0', 'liga=0'
    },
  }),
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = false,
  window_decorations = "NONE",
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  }
}

return config
