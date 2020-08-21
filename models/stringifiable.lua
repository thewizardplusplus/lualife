---
-- @classmod Stringifiable

local inspect = require("inspect")

local Stringifiable = {}

---
-- @treturn string
-- @raise * "stringify the class without a __data() metamethod"
--   * "stringify the class with the __data field that isn't a function"
function Stringifiable:__tostring()
  local metatable = getmetatable(self)
  if not metatable or not metatable.__data then
    error("stringify the class without a __data() metamethod")
  end
  if type(metatable.__data) ~= "function" then
    error("stringify the class with the __data field that isn't a function")
  end

  return inspect(self:__data(), {
    indent = "",
    newline = "",
  })
end

return Stringifiable
