---
-- @module sets

local Field = require("lualife.models.field")

local sets = {}

---
-- @tparam Field base
-- @tparam Field additional
-- @treturn Field
function sets.union(base, additional)
  assert(base.isInstanceOf and base:isInstanceOf(Field))
  assert(additional.isInstanceOf and additional:isInstanceOf(Field))

  return base:map(function(point, contains)
    return contains or additional:contains(point)
  end)
end

---
-- @tparam Field base
-- @tparam Field additional
-- @treturn Field
function sets.complement(base, additional)
  assert(base.isInstanceOf and base:isInstanceOf(Field))
  assert(additional.isInstanceOf and additional:isInstanceOf(Field))

  return base:map(function(point, contains)
    return contains and not additional:contains(point)
  end)
end

---
-- @tparam Field base
-- @tparam Field additional
-- @treturn Field
function sets.intersection(base, additional)
  assert(base.isInstanceOf and base:isInstanceOf(Field))
  assert(additional.isInstanceOf and additional:isInstanceOf(Field))

  return base:map(function(point, contains)
    return contains and additional:contains(point)
  end)
end

return sets
