---
-- @classmod PlacedField

local middleclass = require("middleclass")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local Field = require("lualife.models.field")

local PlacedField = middleclass("PlacedField", Field)

---
-- @function new
-- @tparam Size size
-- @tparam Point offset
-- @treturn PlacedField
function PlacedField:initialize(size, offset)
  assert(size:isInstanceOf(Size))
  assert(offset:isInstanceOf(Point))

  Field.initialize(self, size)

  self.offset = offset
end

return PlacedField
