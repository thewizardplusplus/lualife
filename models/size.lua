---
-- @classmod Size

local middleclass = require("middleclass")
local Point = require("lualife.models.point")

local Size = middleclass("Size")

---
-- @function new
-- @tparam int width [0, ∞)
-- @tparam int height [0, ∞)
-- @treturn Size
function Size:initialize(width, height)
  assert(type(width) == "number")
  assert(type(height) == "number")

  self.width = width
  self.height = height
end

---
-- @tparam Point point
-- @treturn bool
function Size:_contains(point)
  assert(point:isInstanceOf(Point))

  return point.x >= 0 and point.x <= self.width - 1
    and point.y >= 0 and point.y <= self.height - 1
end

---
-- @tparam Size other
-- @tparam[opt=(0 0)] Point offset
-- @treturn bool
function Size:_fits(other, offset)
  offset = offset or Point:new(0, 0)

  assert(other:isInstanceOf(Size))
  assert(offset:isInstanceOf(Point))

  return offset.x >= 0 and offset.x <= other.width - self.width
    and offset.y >= 0 and offset.y <= other.height - self.height
end

return Size
