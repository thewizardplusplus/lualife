---
-- @classmod Size

local middleclass = require("middleclass")
local Stringifiable = require("lualife.models.stringifiable")
local Point = require("lualife.models.point")

local Size = middleclass("Size")
Size:include(Stringifiable)

---
-- @table instance
-- @tfield int width [0, ∞)
-- @tfield int height [0, ∞)

---
-- @function new
-- @tparam int width [0, ∞)
-- @tparam int height [0, ∞)
-- @treturn Size
function Size:initialize(width, height)
  assert(type(width) == "number" and width >= 0)
  assert(type(height) == "number" and height >= 0)

  self.width = width
  self.height = height
end

---
-- @treturn tab table with instance fields
function Size:__data()
  return {
    width = self.width,
    height = self.height,
  }
end

---
-- @function __tostring
-- @treturn string stringified table with instance fields
-- @see Stringifiable

---
-- @tparam Point point
-- @treturn bool
function Size:_contains(point)
  assert(point.isInstanceOf and point:isInstanceOf(Point))

  return point.x >= 0 and point.x <= self.width - 1
    and point.y >= 0 and point.y <= self.height - 1
end

---
-- @tparam Size other
-- @tparam[opt=(0 0)] Point self_offset
-- @treturn bool
function Size:_fits(other, self_offset)
  self_offset = self_offset or Point:new(0, 0)

  assert(other.isInstanceOf and other:isInstanceOf(Size))
  assert(self_offset.isInstanceOf and self_offset:isInstanceOf(Point))

  return self_offset.x >= 0 and self_offset.x <= other.width - self.width
    and self_offset.y >= 0 and self_offset.y <= other.height - self.height
end

return Size
