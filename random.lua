---
-- @module random

local assertions = require("luatypechecks.assertions")
local Range = require("luamath.models.range")
local Field = require("lualife.models.field")

local random = {}

---
-- @tparam Field sample
-- @tparam[opt=0.5] number filling [0, 1]
-- @treturn Field
function random.generate(sample, filling)
  filling = filling or 0.5

  assertions.is_instance(sample, Field)
  assertions.is_number(filling)

  return sample:map(function()
    return math.random() < filling
  end)
end

---
-- @tparam Field sample
-- @tparam[opt=0.5] number filling [0, 1]
-- @tparam[optchain=Range:new(0, math.huge)] Range count_range
-- @treturn Field
function random.generate_with_limits(sample, filling, count_range)
  filling = filling or 0.5
  count_range = count_range or Range:new(0, math.huge)

  assertions.is_instance(sample, Field)
  assertions.is_number(filling)
  assertions.is_instance(count_range, Range)

  local field
  repeat
    field = random.generate(sample, filling)
  until count_range:contains(field:count())

  return field
end

return random
