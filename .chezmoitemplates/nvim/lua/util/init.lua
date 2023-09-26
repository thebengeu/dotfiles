local exports = {}

exports.filter = function(input, callback)
  local output = {}

  for _, value in ipairs(input) do
    if callback(value) then
      table.insert(output, value)
    end
  end

  return output
end

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

    vim.schedule(function()
      if system_obj.code == 0 then
        vim.notify(
          system_obj.stdout
            .. system_obj.stderr
            .. "Executed in "
            .. math.floor((end_time - start_time) / 1e6)
            .. "ms"
        )
      else
        qf_item.type = "E"

        add_lines_to_qf(system_obj.stdout, qf_item)
        add_lines_to_qf(system_obj.stderr, qf_item)

        vim.cmd.copen()
      end

      vim.cmd.cbottom()
    end)
  end)
end

exports.normname = function(name)
  return (name:gsub("[%.%-]?nvim%-?", ""))
end

exports.visual_lines = function()
  local lines = { vim.fn.line("v"), vim.fn.line(".") }

  table.sort(lines)

  return lines
end

return exports
