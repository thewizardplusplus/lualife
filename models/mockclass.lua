---
-- @classmod MockClass

local middleclass = require("middleclass")
local types = require("lualife.types")
local Stringifiable = require("lualife.models.stringifiable")

local MockClass = middleclass("MockClass")
MockClass:include(Stringifiable)

---
-- @table instance
-- @tfield number number
-- @tfield string text

---
-- @function new
-- @tparam number number
-- @tparam string text
-- @treturn MockClass
function MockClass:initialize(number, text)
  assert(types.is_number_with_limits(number))
  assert(type(text) == "string")

  self.number = number
  self.text = text
end

---
-- @treturn tab table with instance fields
function MockClass:__data()
  return {
    number = self.number,
    text = self.text,
  }
end

---
-- @function __tostring
-- @treturn string stringified table with instance fields
-- @see Stringifiable

return MockClass
