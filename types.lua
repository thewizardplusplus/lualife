---
-- @module types

local types = {}

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
-- @tparam[opt=0] number minimum
-- @tparam[optchain=math.huge] number maximum
-- @treturn bool
function types.is_number_with_limits(number, minimum, maximum)
  minimum = minimum or 0
  maximum = maximum or math.huge

  assert(type(minimum) == "number")
  assert(type(maximum) == "number")

  return type(number) == "number"
    and number >= minimum
    and number <= maximum
end

return types
