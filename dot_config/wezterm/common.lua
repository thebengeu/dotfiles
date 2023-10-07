local M = {}

M.tmux_detached_session =
  "tmux has-session -t 0 2>/dev/null || tmux new-session -c ~ -d -s 0"
M.fish_tmux_detached_session = {
  "/usr/bin/fish",
  "-C",
  M.tmux_detached_session,
}

M.map = function(input_table, callback)
  local output_table = {}

  for key, value in pairs(input_table) do
    table.insert(output_table, callback(value, key))
  end

  return output_table
end

return M
