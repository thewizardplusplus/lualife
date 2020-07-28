---
-- @classmod Size

local middleclass = require("middleclass")

local Size = middleclass("Size")

---
-- @param width number
-- @param height number
function Size:initialize(width, height)
  assert(type(width) == "number")
  assert(type(height) == "number")

  self.width = width
  self.height = height
end

return Size
