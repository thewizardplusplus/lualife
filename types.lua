---
-- @module types

local types = {}

---
-- @tparam any value
-- @treturn bool
function types.to_boolean(value)
  return value and true or false
end

---
-- @tparam any value
-- @tparam string metamethod
-- @treturn bool
function types.has_metamethod(value, metamethod)
  local metatable = getmetatable(value)
  return types.to_boolean(metatable)
    and types.is_callable(metatable[metamethod])
end

---
-- @tparam any value
-- @treturn bool
function types.is_callable(value)
  if type(value) == "function" then
    return true
  end

  return types.has_metamethod(value, "__call")
end

---
-- @tparam any instance
-- @tparam tab class class created via the middleclass library
-- @treturn bool
function types.is_instance(instance, class)
  return type(instance) == "table"
    and type(instance.isInstanceOf) == "function"
    and instance:isInstanceOf(class)
end

---
-- @tparam number number
-- @tparam[opt=-math.huge] number minimum
-- @tparam[optchain=math.huge] number maximum [minimum, ∞)
-- @treturn bool
function types.is_number_with_limits(number, minimum, maximum)
  minimum = minimum or -math.huge
  maximum = maximum or math.huge

  assert(type(minimum) == "number")
  assert(type(maximum) == "number" and maximum >= minimum)

  return type(number) == "number"
    and number >= minimum
    and number <= maximum
end

return types
