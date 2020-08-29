---
-- @classmod Stringifiable

local inspect = require("inspect")
local types = require("lualife.types")

local Stringifiable = {}

---
-- @treturn string stringified result of the __data() metamethod
function Stringifiable:__tostring()
  local metatable = getmetatable(self)
  assert(metatable and metatable.__data)
  assert(types.is_callable(metatable.__data))

  return inspect(self:__data(), {
    indent = "",
    newline = "",
  })
end

return Stringifiable
