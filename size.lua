local middleclass = require("lualife.vendor.middleclass.middleclass")

local Size = middleclass("Size")

function Size:initialize(width, height)
  assert(type(width) == "number")
  assert(type(height) == "number")

  self.width = width
  self.height = height
end

return Size
