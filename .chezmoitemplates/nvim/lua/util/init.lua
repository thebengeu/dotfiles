local exports = {}

exports.async_run = function(command)
  return function()
    vim.cmd.AsyncRun("-close -mode=term -rows=5 " .. command)
  end
end

exports.map = function(table, callback)
  local mapped_table = {}

  for key, value in pairs(table) do
    mapped_table[key] = callback(value)
  end

  return mapped_table
end

return exports
