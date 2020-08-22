---
-- @classmod Stringifiable

local inspect = require("inspect")

local Stringifiable = {}

---
-- @treturn string stringified result of the __data() metamethod
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
