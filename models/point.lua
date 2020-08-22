---
-- @classmod Point

local middleclass = require("middleclass")
local Stringifiable = require("lualife.models.stringifiable")

local Point = middleclass("Point")
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
  assert(type(x) == "number")
  assert(type(y) == "number")

  self.x = x
  self.y = y
end

-- @treturn tab
function Point:__data()
  return {
    x = self.x,
    y = self.y,
  }
end

---
-- @tparam Point point
-- @treturn Point
function Point:translate(point)
  assert(point.isInstanceOf and point:isInstanceOf(Point))

  return Point:new(self.x + point.x, self.y + point.y)
end

---
-- @tparam number factor
-- @treturn Point
function Point:scale(factor)
  assert(type(factor) == "number")

  return Point:new(self.x * factor, self.y * factor)
end

return Point
