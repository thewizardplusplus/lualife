---
-- @classmod PlacedField

local middleclass = require("middleclass")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local Field = require("lualife.models.field")

local PlacedField = middleclass("PlacedField", Field)

---
-- @tparam Field field
-- @tparam Point[opt] offset default: (0, 0)
-- @treturn PlacedField
function PlacedField.static:place(field, offset)
  offset = offset or Point:new(0, 0)

  assert(field:isInstanceOf(Field))
  assert(offset:isInstanceOf(Point))

  local placed_field = PlacedField:new(field.size, offset)
  placed_field.cells = field.cells

  return placed_field
end

---
-- @function new
-- @tparam Size size
-- @tparam Point[opt] offset default: (0, 0)
-- @treturn PlacedField
function PlacedField:initialize(size, offset)
  offset = offset or Point:new(0, 0)

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

  local local_point = self:to_local(point)
  return Field.contains(self, local_point)
end

---
-- @tparam PlacedField other
-- @treturn bool
function PlacedField:fits(other)
  assert(other:isInstanceOf(PlacedField))

  local offsets_difference = self.offset:translate(other:inverted_offset())
  return self.size:fits(other.size, offsets_difference)
end

---
-- @tparam Point point
function PlacedField:set(point)
  assert(point:isInstanceOf(Point))

  local local_point = self:to_local(point)
  Field.set(self, local_point)
end

---
-- @param mapper func(point: Point, contains: bool): bool
-- @treturn PlacedField
function PlacedField:map(mapper)
  assert(type(mapper) == "function")

  local field = Field.map(self, function(point)
    local global_point = self:to_global(point)
    local contains = self:contains(global_point)
    return mapper(global_point, contains)
  end)
  return PlacedField:place(field, self.offset)
end

---
-- @treturn Point
function PlacedField:inverted_offset()
  return self.offset:scale(-1)
end

---
-- @tparam Point point
-- @treturn Point
function PlacedField:to_local(point)
  assert(point:isInstanceOf(Point))

  return point:translate(self:inverted_offset())
end

---
-- @tparam Point point
-- @treturn Point
function PlacedField:to_global(point)
  assert(point:isInstanceOf(Point))

  return point:translate(self.offset)
end

return PlacedField
