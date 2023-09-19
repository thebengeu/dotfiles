local exports = {}

local map = function(input, callback)
  local output = {}

  if type(input) == "table" then
    for key, value in pairs(input) do
      table.insert(output, callback(value, key))
    end
  else
    for value in input do
      table.insert(output, callback(value))
    end
  end

  return output
end

exports.map = map

local add_lines_to_qf = function(lines)
  vim.fn.setqflist(
    map(lines:gmatch("[^%c]+"), function(line)
      return { text = line }
    end),
    "a"
  )
end

exports.async_run = function(command)
  add_lines_to_qf(table.concat(command, " "))

  local start_time = vim.loop.hrtime()

  vim.system(command, {}, function(system_obj)
    vim.schedule(function()
      local end_time = vim.loop.hrtime()

      add_lines_to_qf(system_obj.stdout)
      add_lines_to_qf(system_obj.stderr)

      if system_obj.code == 0 then
        add_lines_to_qf(
          "Executed in " .. math.floor((end_time - start_time) / 1e6) .. "ms"
        )
      else
        vim.cmd.copen()
        vim.cmd.clast()
      end
    end)
  end)
end

exports.normname = function(name)
  return (name:gsub("[%.%-]?nvim%-?", ""))
end

return exports
