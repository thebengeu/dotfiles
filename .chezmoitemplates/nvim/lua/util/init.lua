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

local add_lines_to_qf = function(lines, qf_item)
  vim.fn.setqflist(
    map(lines:gmatch("[^%c]+"), function(line)
      return vim.tbl_extend("force", qf_item, {
        text = line,
      })
    end),
    "a"
  )
end

exports.async_run = function(command)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local qf_item = {
    col = cursor[2],
    filename = vim.api.nvim_buf_get_name(0),
    lnum = cursor[1],
    type = "I",
  }

  add_lines_to_qf(table.concat(command, " "):gsub("^sh %-c ", ""), qf_item)

  local start_time = vim.loop.hrtime()

  vim.system(command, nil, function(system_obj)
    local end_time = vim.loop.hrtime()

    if system_obj.code ~= 0 then
      qf_item.type = "E"
    end

    vim.schedule(function()
      add_lines_to_qf(system_obj.stdout, qf_item)
      add_lines_to_qf(system_obj.stderr, qf_item)

      if system_obj.code == 0 then
        add_lines_to_qf(
          "Executed in " .. math.floor((end_time - start_time) / 1e6) .. "ms",
          qf_item
        )
      else
        vim.cmd.copen()
      end

      vim.cmd.clast()
    end)
  end)
end

exports.normname = function(name)
  return (name:gsub("[%.%-]?nvim%-?", ""))
end

return exports
