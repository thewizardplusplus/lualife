-- luacheck: no max comment line length

---
-- @classmod Field

local middleclass = require("middleclass")
local assertions = require("luatypechecks.assertions")
local Nameable = require("luaserialization.nameable")
local Stringifiable = require("luaserialization.stringifiable")
local Vector2D = require("luamath.vector2d")
local Size = require("luamath.models.size")
local BoundingBox = require("luamath.models.boundingbox")

local Field = middleclass("Field")
Field:include(Nameable)
Field:include(Stringifiable)

---
-- @function schema
-- @static
-- @treturn tab JSON Schema for this class
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
function Field.static.schema()
  return {
    type = "object",
    required = {"size", "bounds", "cells"},
    properties = {
      size = Size.schema(),
      bounds = BoundingBox.schema(),
      cells = { type = "array", items = Vector2D.schema() },
    },
  }
end

---
-- @function from_options
-- @static
-- @tparam tab options constructor options conforming to the JSON Schema
--   returned by @{Field.schema|Field.schema()}
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
-- @treturn Field
function Field.static.from_options(options)
  assertions.is_table(options)

  local field = Field:new(options.size)
  for _, point in ipairs(options.cells) do
    field:set(point)
  end

  return field
end

---
-- @table instance
-- @tfield Size size
-- @tfield BoundingBox bounds
-- @tfield tab _cells
--   map[string, bool]; key - stringified Vector2D, value - always true

---
-- @function new
-- @tparam Size size
-- @treturn Field
function Field:initialize(size)
  assertions.is_instance(size, Size)

  self.size = size
  self.bounds = BoundingBox:new(
    Vector2D:new(0, 0),
    Vector2D:new(size.width - 1, size.height - 1)
  )
  self._cells = {}
end

---
-- @treturn tab table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
function Field:__data()
  local cells = {}
  self:map(function(point, contains)
    assertions.is_instance(point, Vector2D)
    assertions.is_boolean(contains)

    if contains then
      table.insert(cells, point)
    end
  end)

  return {
    size = self.size,
    bounds = self.bounds,
    cells = cells,
  }
end

---
-- @function __tostring
-- @treturn string stringified table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)

---
-- @treturn int [0, self.size.width * self.size.height]
function Field:count()
  local count = 0
  for _ in pairs(self._cells) do
    count = count + 1
  end

  return count
end

---
-- @tparam Vector2D point
-- @treturn bool
function Field:contains(point)
  assertions.is_instance(point, Vector2D)

  return self.bounds:contains(point) and self._cells[tostring(point)] == true
end

---
-- @tparam Field other
-- @treturn bool
function Field:fits(other)
  assertions.is_instance(other, Field)

  return other.bounds:contains(self.bounds)
end

---
-- @tparam Vector2D point
function Field:set(point)
  assertions.is_instance(point, Vector2D)

  if self.bounds:contains(point) then
    self._cells[tostring(point)] = true
  end
end

---
-- @tparam func mapper func(point: Vector2D, contains: bool): bool
-- @treturn Field
function Field:map(mapper)
  assertions.is_callable(mapper)

  local field = Field:new(self.size)
  local x_range, y_range = field.bounds:x_range(), field.bounds:y_range()
  for y = y_range.min, y_range.max do
    for x = x_range.min, x_range.max do
      local point = Vector2D:new(x, y)
      local contains = self:contains(point)
      if mapper(point, contains) then
        field:set(point)
      end
    end
  end

  return field
end

return Field
