---
-- @module matrix

local Field = require("lualife.models.field")

local matrix = {}

---
-- @tparam Field field
-- @treturn Field
function matrix.rotate(field)
  assert(field:isInstanceOf(Field))

  return field
end

return matrix
