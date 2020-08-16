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
-- @tparam Size other
-- @tparam Point[opt] offset default: (0, 0)
-- @treturn bool
function Size:fits(other, offset)
  offset = offset or Point:new(0, 0)

  assert(other:isInstanceOf(Size))
  assert(offset:isInstanceOf(Point))

  return offset.x >= 0 and offset.x <= other.width - self.width
    and offset.y >= 0 and offset.y <= other.height - self.height
end

return Size
