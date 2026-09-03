-- luacheck: no max comment line length

---
-- @module matrix

local assertions = require("luatypechecks.assertions")
local Vector2D = require("luamath.vector2d")
local Matrix3x3 = require("luamath.matrix3x3")
local mathutils = require("luamath.utils")
local Field = require("lualife.models.field")

local function _snap_to_integer_grid(point)
  assertions.is_instance(point, Vector2D)

  return Vector2D:new(mathutils.round(point.x), mathutils.round(point.y))
end

local matrix = {}

---
-- @tparam Field field field whose width equals its height
-- @treturn Field
-- @raise "field must be square"
function matrix.rotate(field)
  assertions.is_instance(field, Field)

  if field.size.width ~= field.size.height then
    error("field must be square")
  end

  local offset = field.bounds.min
  local transformation = Matrix3x3.translate(offset)
    -- shift the rotated X range from [-(width - 1), 0] back to [0, width - 1]
    * Matrix3x3.translate(Vector2D:new(field.size.width - 1, 0))
    * Matrix3x3.rotate(math.pi / 2)
    * Matrix3x3.translate(-offset)

  -- create an empty field of the same concrete class
  local rotated_field = field:map(function() return false end)

  local x_range, y_range = field.bounds:x_range(), field.bounds:y_range()
  for y = y_range.min, y_range.max do
    for x = x_range.min, x_range.max do
      local point = Vector2D:new(x, y)
      if field:contains(point) then
        -- trigonometric matrices may produce values such as `1.0000000000000002`;
        -- cell coordinates must remain integers
        rotated_field:set(_snap_to_integer_grid(point * transformation))
      end
    end
  end

  return rotated_field
end

return matrix
