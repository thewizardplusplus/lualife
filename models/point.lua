-- luacheck: no max comment line length

---
-- @classmod Point

local middleclass = require("middleclass")
local assertions = require("luatypechecks.assertions")
local Nameable = require("luaserialization.nameable")
local Stringifiable = require("luaserialization.stringifiable")

local Point = middleclass("Point")
Point:include(Nameable)
Point:include(Stringifiable)

---
-- @table instance
-- @tfield number x
-- @tfield number y

---
-- @function new
-- @tparam number x
-- @tparam number y
-- @treturn Point
function Point:initialize(x, y)
  assertions.is_number(x)
  assertions.is_number(y)

  self.x = x
  self.y = y
end

---
-- @treturn tab table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
function Point:__data()
  return {
    x = self.x,
    y = self.y,
  }
end

---
-- @function __tostring
-- @treturn string stringified table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)

---
-- @tparam Point point
-- @treturn Point
function Point:translate(point)
  assertions.is_instance(point, Point)

  return Point:new(self.x + point.x, self.y + point.y)
end

---
-- @tparam number factor
-- @treturn Point
function Point:scale(factor)
  assertions.is_number(factor)

  return Point:new(self.x * factor, self.y * factor)
end

return Point
