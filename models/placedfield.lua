-- luacheck: no max comment line length

---
-- @classmod PlacedField

local middleclass = require("middleclass")
local assertions = require("luatypechecks.assertions")
local Vector2D = require("luamath.vector2d")
local Matrix3x3 = require("luamath.matrix3x3")
local Size = require("luamath.models.size")
local BoundingBox = require("luamath.models.boundingbox")
local Field = require("lualife.models.field")
local _ENV = require("compat53.module")
if _VERSION == "Lua 5.1" then
  setfenv(1, _ENV)
end

local PlacedField = middleclass("PlacedField", Field)

---
-- @function schema
-- @static
-- @treturn tab JSON Schema for this class
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
function PlacedField.static.schema()
  local schema = Field.schema()
  table.insert(schema.required, "local_bounds")
  schema.properties.local_bounds = BoundingBox.schema()

  return schema
end

---
-- @function from_options
-- @static
-- @tparam tab options constructor options conforming to the JSON Schema
--   returned by @{PlacedField.schema|PlacedField.schema()}
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
-- @treturn PlacedField
function PlacedField.static.from_options(options)
  assertions.is_table(options)

  local field = PlacedField:new(options.size, options.bounds:position())
  for _, point in ipairs(options.cells) do
    field:set(point)
  end

  return field
end

---
-- @function place
-- @static
-- @tparam Field field
-- @tparam[opt=Vector2D:new(0, 0)] Vector2D offset
-- @treturn PlacedField
function PlacedField.static.place(field, offset)
  offset = offset or Vector2D:new(0, 0)

  assertions.is_instance(field, Field)
  assertions.is_instance(offset, Vector2D)

  local placed_field = PlacedField:new(field.size, offset)
  field:map(function(point, contains)
    assertions.is_instance(point, Vector2D)
    assertions.is_boolean(contains)

    if not contains then
      return
    end

    local local_point = point - field.bounds:position()
    placed_field:set(placed_field:_to_global(local_point))
  end)

  return placed_field
end

---
-- @table instance
-- @tfield Size size
-- @tfield BoundingBox local_bounds bounds in local coordinates
-- @tfield BoundingBox bounds bounds in global coordinates
-- @tfield {[string]=bool,...} _cells key - stringified Vector2D, value - always true

---
-- @function new
-- @tparam Size size
-- @tparam[opt=Vector2D:new(0, 0)] Vector2D offset
-- @treturn PlacedField
function PlacedField:initialize(size, offset)
  offset = offset or Vector2D:new(0, 0)

  assertions.is_instance(size, Size)
  assertions.is_instance(offset, Vector2D)

  Field.initialize(self, size)

  self.local_bounds = self.bounds
  self.bounds = self.bounds + offset
end

---
-- @treturn tab table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
function PlacedField:__data()
  local data = Field.__data(self)
  data.local_bounds = self.local_bounds

  return data
end

---
-- @function __tostring
-- @treturn string stringified table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)

---
-- @function count
-- @treturn int [0, self.size.width * self.size.height]

---
-- @treturn Vector2D
function PlacedField:offset()
  return self.bounds:position()
end

---
-- @tparam Vector2D point
-- @treturn bool
function PlacedField:contains(point)
  assertions.is_instance(point, Vector2D)

  local local_point = self:_to_local(point)
  return self:_call_with_local_bounds(Field.contains, local_point)
end

---
-- @tparam PlacedField other
-- @treturn bool
function PlacedField:fits(other)
  assertions.is_instance(other, PlacedField)

  return Field.fits(self, other)
end

---
-- @tparam Vector2D point
function PlacedField:set(point)
  assertions.is_instance(point, Vector2D)

  local local_point = self:_to_local(point)
  self:_call_with_local_bounds(Field.set, local_point)
end

---
-- @tparam func mapper func(point: Vector2D, contains: bool): bool
-- @treturn PlacedField
function PlacedField:map(mapper)
  assertions.is_callable(mapper)

  local field = Field.map(self, function(point)
    assertions.is_instance(point, Vector2D)

    local global_point = self:_to_global(point)
    local contains = self:contains(global_point)
    return mapper(global_point, contains)
  end)
  return PlacedField.place(field, self:offset())
end

---
-- @tparam Vector2D point
-- @treturn Vector2D
function PlacedField:_to_local(point)
  assertions.is_instance(point, Vector2D)

  return point * Matrix3x3.translate(-self:offset())
end

---
-- @tparam Vector2D point
-- @treturn Vector2D
function PlacedField:_to_global(point)
  assertions.is_instance(point, Vector2D)

  return point * Matrix3x3.translate(self:offset())
end

---
-- @tparam func method method of Field
-- @param ... method arguments
-- @return ... method results
function PlacedField:_call_with_local_bounds(method, ...)
  assertions.is_callable(method)

  local global_bounds = self.bounds
  self.bounds = self.local_bounds

  local arguments = table.pack(...)
  local results = table.pack(pcall(function()
    return method(self, table.unpack(arguments, 1, arguments.n))
  end))
  self.bounds = global_bounds

  if not results[1] then
    error(results[2], 0)
  end

  return table.unpack(results, 2, results.n)
end

return PlacedField
