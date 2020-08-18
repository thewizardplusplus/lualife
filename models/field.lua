---
-- @classmod Field

local middleclass = require("middleclass")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")

local function to_boolean(value)
  return value and true or false
end

local Field = middleclass("Field")

---
-- @function new
-- @tparam Size size
-- @treturn Field
function Field:initialize(size)
  assert(size:isInstanceOf(Size))

  self.size = size
  self._cells = {}
end

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
-- @tparam Point point
-- @treturn bool
function Field:contains(point)
  assert(point:isInstanceOf(Point))

  local contains = self._cells[tostring(point)]
  return to_boolean(contains)
end

---
-- @tparam Field other
-- @treturn bool
function Field:fits(other)
  assert(other:isInstanceOf(Field))

  return self.size:_fits(other.size)
end

---
-- @tparam Point point
function Field:set(point)
  assert(point:isInstanceOf(Point))

  if self.size:_contains(point) then
    self._cells[tostring(point)] = true
  end
end

---
-- @param mapper func(point: Point, contains: bool): bool
-- @treturn Field
function Field:map(mapper)
  assert(type(mapper) == "function")

  local field = Field:new(self.size)
  for y = 0, self.size.height - 1 do
    for x = 0, self.size.width - 1 do
      local point = Point:new(x, y)
      local contains = self:contains(point)
      if mapper(point, contains) then
        field:set(point)
      end
    end
  end

  return field
end

return Field
