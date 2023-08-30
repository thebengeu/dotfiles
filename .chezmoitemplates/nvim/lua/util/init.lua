local exports = {}
local methods = {}

exports.async_run = function(command)
  return function()
    vim.cmd.AsyncRun("-close -mode=term -rows=5 " .. command)
  end
end

local call_if_not_empty = function(fun, state_x, ...)
  if state_x == nil then
    return nil
  end
  return state_x, fun(...)
end

local iterator_mt = {
  -- usually called by for-in loop
  __call = function(self, param, state)
    return self.gen(param, state)
  end,
  __tostring = function(self)
    return "<generator>"
  end,
  -- add all exported methods
  __index = methods,
}
local wrap = function(gen, param, state)
  return setmetatable({
    gen = gen,
    param = param,
    state = state,
  }, iterator_mt), param, state
end

local nil_gen = function(_param, _state)
  return nil
end

local string_gen = function(param, state)
  local state = state + 1
  if state > #param then
    return nil
  end
  local r = string.sub(param, state, state)
  return state, r
end

local pairs_gen = pairs({ a = 0 }) -- get the generating function from pairs
local map_gen = function(tab, key)
  local value
  local key, value = pairs_gen(tab, key)
  return key, key, value
end

local rawiter = function(obj, param, state)
  assert(obj ~= nil, "invalid iterator")
  if type(obj) == "table" then
    local mt = getmetatable(obj)
    if mt ~= nil then
      if mt == iterator_mt then
        return obj.gen, obj.param, obj.state
      elseif mt.__ipairs ~= nil then
        return mt.__ipairs(obj)
      elseif mt.__pairs ~= nil then
        return mt.__pairs(obj)
      end
    end
    if #obj > 0 then
      -- array
      return ipairs(obj)
    else
      -- hash
      return map_gen, obj, nil
    end
  elseif type(obj) == "function" then
    return obj, param, state
  elseif type(obj) == "string" then
    if #obj == 0 then
      return nil_gen, nil, nil
    end
    return string_gen, obj, 0
  end
  error(string.format('object %s of type "%s" is not iterable', obj, type(obj)))
end

local method1 = function(fun)
  return function(self, arg1)
    return fun(arg1, self.gen, self.param, self.state)
  end
end

local export1 = function(fun)
  return function(arg1, gen, param, state)
    return fun(arg1, rawiter(gen, param, state))
  end
end

local map_gen = function(param, state)
  local gen_x, param_x, fun = param[1], param[2], param[3]
  return call_if_not_empty(fun, gen_x(param_x, state))
end

local map = function(fun, gen, param, state)
  return wrap(map_gen, { gen, param, fun }, state)
end
methods.map = method1(map)
exports.map = export1(map)

return exports
