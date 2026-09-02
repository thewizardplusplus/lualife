---
-- @module life

local assertions = require("luatypechecks.assertions")
local Vector2D = require("luamath.vector2d")
local Range = require("luamath.models.range")
local Field = require("lualife.models.field")

local _NEIGHBOR_OFFSET_RANGE = Range:new(-1, 1)

local life = {}

---
-- @tparam Field field
-- @treturn Field
function life.populate(field)
  assertions.is_instance(field, Field)

  return field:map(function(point, contains)
    assertions.is_instance(point, Vector2D)
    assertions.is_boolean(contains)

    local neighbors = life._neighbors(field, point)
    return neighbors == 3 or (neighbors == 2 and contains)
  end)
end

---
-- @tparam Field field
-- @tparam Vector2D point
-- @treturn int [0, 8]
function life._neighbors(field, point)
  assertions.is_instance(field, Field)
  assertions.is_instance(point, Vector2D)

  local neighbors = 0
  for dy = _NEIGHBOR_OFFSET_RANGE.min, _NEIGHBOR_OFFSET_RANGE.max do
    for dx = _NEIGHBOR_OFFSET_RANGE.min, _NEIGHBOR_OFFSET_RANGE.max do
      local translated_point = point + Vector2D:new(dx, dy)
      local alive = field:contains(translated_point)
      local central = dx == 0 and dy == 0
      if alive and not central then
        neighbors = neighbors + 1
      end
    end
  end

  return neighbors
end

return life
