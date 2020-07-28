---
-- @classmod Point

local middleclass = require("middleclass")

local Point = middleclass("Point")

---
-- @tparam int x
-- @tparam int y
function Point:initialize(x, y)
  assert(type(x) == "number")
  assert(type(y) == "number")

  self.x = x
  self.y = y
end

---
-- @return string
function Point:__tostring()
  return string.format("(%d, %d)", self.x, self.y)
end

---
-- @tparam Point point
-- @return Point
function Point:translate(point)
  assert(point:isInstanceOf(Point))

  return Point:new(self.x + point.x, self.y + point.y)
end

return Point
