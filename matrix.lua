---
-- @module matrix

local Field = require("lualife.models.field")

local matrix = {}

---
-- @tparam Field field
-- @treturn Field
function matrix.rotate(field)
  assert(field:isInstanceOf(Field))

  if field.size.width ~= field.size.height then
    error("rotation of the non-square matrix")
  end

  return field
end

return matrix
