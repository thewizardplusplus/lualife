---
-- @module sets

local Point = require("lualife.models.point")
local Field = require("lualife.models.field")

local sets = {}

---
-- @tparam Field base
-- @tparam Field additional
-- @treturn Field
function sets.union(base, additional)
  assert(base:isInstanceOf(Field))
  assert(additional:isInstanceOf(Field))

  return base:map(function(point, contains)
    return contains or additional:contains(point)
  end)
end

---
-- @tparam Field base
-- @tparam Field additional
-- @treturn Field
function sets.complement(base, additional)
  assert(base:isInstanceOf(Field))
  assert(additional:isInstanceOf(Field))

  return base:map(function(point, contains)
    return contains and not additional:contains(point)
  end)
end

---
-- @tparam Field base
-- @tparam Field additional
-- @tparam Point offset
-- @treturn Field
function sets.intersection(base, additional, offset)
  assert(base:isInstanceOf(Field))
  assert(additional:isInstanceOf(Field))
  assert(offset:isInstanceOf(Point))

  local inverted_offset = offset:scale(-1)
  return base:map(function(point, contains)
    local shifted_point = point:translate(inverted_offset)
    return contains and additional:contains(shifted_point)
  end)
end

return sets
