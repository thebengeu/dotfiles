local exports = {}

exports.async_run = function(command)
  return function()
    vim.cmd.AsyncRun("-mode=term -rows=5 " .. command)
  end
end

exports.map = function(input_table, callback)
  local output_table = {}

  for key, value in pairs(input_table) do
    table.insert(output_table, callback(value, key))
  end

  return output_table
end

exports.normname = function(name)
  return (name:gsub("[%.%-]?nvim%-?", ""))
end

return exports
