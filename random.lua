---
-- @module random

local Size = require("lualife.models.size")
local Field = require("lualife.models.field")

local random = {}

---
-- @tparam Field sample
-- @tparam number filling [0, 1]
-- @treturn Field
function random.generate(sample, filling)
  assert(sample:isInstanceOf(Field))
  assert(type(filling) == "number")

  return sample:map(function()
    return math.random() < filling
  end)
end

---
-- @tparam Field sample
-- @tparam number filling [0, 1]
-- @tparam int minimal_count [0, size.width * size.height]
-- @tparam int maximal_count [0, size.width * size.height]
-- @treturn Field
function random.generate_with_limits(
  sample,
  filling,
  minimal_count,
  maximal_count
)
  assert(sample:isInstanceOf(Field))
  assert(type(filling) == "number")
  assert(type(minimal_count) == "number")
  assert(type(maximal_count) == "number")

  local field = nil
  repeat
    field = random.generate(sample, filling)
  until field:count() >= minimal_count and field:count() <= maximal_count

  return field
end

return random
