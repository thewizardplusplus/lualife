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

---
-- @param mapper func(point: Point, contains: bool): bool
-- @treturn Field
function PlacedField:map(mapper)
  assert(type(mapper) == "function")

  return Field.map(self, function(point)
    local global_point = point:translate(self.offset)
    local contains = self:contains(global_point)
    return mapper(global_point, contains)
  end)
end

return PlacedField
