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

---
-- @tparam Point point
-- @treturn bool
function PlacedField:contains(point)
  assert(point:isInstanceOf(Point))

  local inverted_offset = self.offset:scale(-1)
  local local_point = point:translate(inverted_offset)
  return Field.contains(self, local_point)
end

---
-- @tparam Point point
function PlacedField:set(point)
  assert(point:isInstanceOf(Point))

  local inverted_offset = self.offset:scale(-1)
  local local_point = point:translate(inverted_offset)
  Field.set(self, local_point)
end

return PlacedField
