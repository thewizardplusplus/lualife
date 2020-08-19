---
-- @classmod PlacedField

local middleclass = require("middleclass")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local Field = require("lualife.models.field")

local PlacedField = middleclass("PlacedField", Field)

---
-- @function place
-- @static
-- @tparam Field field
-- @tparam[opt=(0 0)] Point offset
-- @treturn PlacedField
function PlacedField.static.place(field, offset)
  offset = offset or Point:new(0, 0)

  assert(field:isInstanceOf(Field))
  assert(offset:isInstanceOf(Point))

  local placed_field = PlacedField:new(field.size, offset)
  placed_field._cells = field._cells

  return placed_field
end

---
-- @function new
-- @tparam Size size
-- @tparam[opt=(0 0)] Point offset
-- @treturn PlacedField
function PlacedField:initialize(size, offset)
  offset = offset or Point:new(0, 0)

  assert(size:isInstanceOf(Size))
  assert(offset:isInstanceOf(Point))

  Field.initialize(self, size)

  self.offset = offset
end

---
-- @function count
-- @treturn int [0, self.size.width * self.size.height]

---
-- @tparam Point point
-- @treturn bool
function PlacedField:contains(point)
  assert(point:isInstanceOf(Point))

  local local_point = self:_to_local(point)
  return Field.contains(self, local_point)
end

---
-- @tparam PlacedField other
-- @treturn bool
function PlacedField:fits(other)
  assert(other:isInstanceOf(PlacedField))

  local offsets_difference = self.offset:translate(other:_inverted_offset())
  return self.size:_fits(other.size, offsets_difference)
end

---
-- @tparam Point point
function PlacedField:set(point)
  assert(point:isInstanceOf(Point))

  local local_point = self:_to_local(point)
  Field.set(self, local_point)
end

---
-- @param mapper func(point: Point, contains: bool): bool
-- @treturn PlacedField
function PlacedField:map(mapper)
  assert(type(mapper) == "function")

  local field = Field.map(self, function(point)
    local global_point = self:_to_global(point)
    local contains = self:contains(global_point)
    return mapper(global_point, contains)
  end)
  return PlacedField.place(field, self.offset)
end

---
-- @treturn Point
function PlacedField:_inverted_offset()
  return self.offset:scale(-1)
end

---
-- @tparam Point point
-- @treturn Point
function PlacedField:_to_local(point)
  assert(point:isInstanceOf(Point))

  return point:translate(self:_inverted_offset())
end

---
-- @tparam Point point
-- @treturn Point
function PlacedField:_to_global(point)
  assert(point:isInstanceOf(Point))

  return point:translate(self.offset)
end

return PlacedField