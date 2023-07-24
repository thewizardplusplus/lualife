---
-- @module types

local types = {}

---
-- @tparam any value
-- @treturn bool
function types.to_boolean(value)
  return value and true or false
end

return types
