---
-- @classmod Stringifiable

local inspect = require("inspect")

local Stringifiable = {}

---
-- @treturn string
function Stringifiable:__tostring()
  local metatable = getmetatable(self)
  assert(metatable and metatable.__data)
  assert(type(metatable.__data) == "function")

  return inspect(self:__data(), {
    indent = "",
    newline = "",
  })
end

return Stringifiable
