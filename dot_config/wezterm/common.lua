local wezterm = require("wezterm")

local M = {}

M.activate_pane = function(pane)
  if pane then
    pane:window():gui_window():focus()
    pane:activate()
  end
end

M.find_pane = function(callback)
  for _, window in ipairs(wezterm.gui.gui_windows()) do
    for _, tab in ipairs(window:mux_window():tabs()) do
      for _, pane in ipairs(tab:panes()) do
        local found_pane = callback(pane)

        if found_pane then
          return pane
        end
      end
    end
  end
end

M.tmux_detached_session =
  "tmux has-session -t 0 2>/dev/null || tmux new-session -c ~ -d -s 0"
M.fish_tmux_detached_session = {
  "/usr/bin/fish",
  "-C",
  M.tmux_detached_session,
}

M.list_extend = function(dst, src)
  for _, item in ipairs(src) do
    table.insert(dst, item)
  end
end

M.map = function(input_table, callback)
  local output_table = {}

  for key, value in pairs(input_table) do
    table.insert(output_table, callback(value, key))
  end

  return output_table
end

return M
