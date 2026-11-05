---
-- @module benchlocalutils

local assertions = require("luatypechecks.assertions")
local Vector2D = require("luamath.vector2d")
local Size = require("luamath.models.size")
local Field = require("lualife.models.field")
local PlacedField = require("lualife.models.placedfield")

local function _for_each_point(field, denominator, phase, visitor)
  assertions.is_instance(field, Field)
  assertions.is_integer(denominator)
  assertions.is_integer(phase)
  assertions.is_callable(visitor)

  local x_range, y_range = field.bounds:x_range(), field.bounds:y_range()
  for y = y_range.min, y_range.max do
    for x = x_range.min, x_range.max do
      local point = Vector2D:new(x, y)
      local local_point = point - field.bounds:position()
      -- this has no special mathematical meaning;
      -- it just produces a regular filling pattern
      local value = local_point:dot(Vector2D:new(17, 31)) + phase
      visitor(point, value % denominator == 0)
    end
  end
end

local benchlocalutils = {}

---
-- @table module
-- @tfield {int,...} SIZES square field sizes used by benchmarks
-- @tfield int DEFAULT_DENOMINATOR default filling denominator

benchlocalutils.SIZES = {5, 10, 20, 40}
benchlocalutils.DEFAULT_DENOMINATOR = 5

---
-- ⚠️. Create a square field filled with a deterministic pattern.
-- @tparam int size positive field width and height
-- @tparam[opt=DEFAULT_DENOMINATOR] int denominator positive filling denominator
-- @tparam[opt=0] int phase filling pattern phase
-- @treturn Field
function benchlocalutils.new_field(size, denominator, phase)
  denominator = denominator or benchlocalutils.DEFAULT_DENOMINATOR
  phase = phase or 0

  assertions.is_integer(size)
  assertions.is_integer(denominator)
  assertions.is_integer(phase)

  local field = Field:new(Size:new(size, size))
  _for_each_point(field, denominator, phase, function(point, matches)
    assertions.is_instance(point, Vector2D)
    assertions.is_boolean(matches)

    if matches then
      field:set(point)
    end
  end)

  return field
end

---
-- ⚠️. Create a square placed field filled with a deterministic pattern.
-- @tparam int size positive field width and height
-- @tparam[opt=DEFAULT_DENOMINATOR] int denominator positive filling denominator
-- @tparam[opt=0] int phase filling pattern phase
-- @tparam[opt=size] int offset field offset on both axes
-- @treturn PlacedField
function benchlocalutils.new_placed_field(size, denominator, phase, offset)
  denominator = denominator or benchlocalutils.DEFAULT_DENOMINATOR
  phase = phase or 0
  offset = offset or size

  assertions.is_integer(size)
  assertions.is_integer(denominator)
  assertions.is_integer(phase)
  assertions.is_integer(offset)

  local field =
    PlacedField:new(Size:new(size, size), Vector2D:new(offset, offset))
  _for_each_point(field, denominator, phase, function(point, matches)
    assertions.is_instance(point, Vector2D)
    assertions.is_boolean(matches)

    if matches then
      field:set(point)
    end
  end)

  return field
end

---
-- ⚠️. Collect all field points or only points matching the filling pattern.
-- @tparam Field field
-- @tparam[opt="all"] "all"|"pattern" mode point selection mode
-- @tparam[opt=DEFAULT_DENOMINATOR] int denominator positive filling denominator
-- @tparam[opt=0] int phase filling pattern phase
-- @treturn {Vector2D,...}
function benchlocalutils.collect_points(field, mode, denominator, phase)
  mode = mode or "all"
  denominator = denominator or benchlocalutils.DEFAULT_DENOMINATOR
  phase = phase or 0

  assertions.is_instance(field, Field)
  assertions.is_enumeration(mode, {"all", "pattern"})
  assertions.is_integer(denominator)
  assertions.is_integer(phase)

  local points = {}
  _for_each_point(field, denominator, phase, function(point, matches)
    assertions.is_instance(point, Vector2D)
    assertions.is_boolean(matches)

    if mode == "all" or matches then
      table.insert(points, point)
    end
  end)

  return points
end

return benchlocalutils
