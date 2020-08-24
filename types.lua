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

return types
