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
  self.cells = {}
end

---
-- @tparam Point point
-- @treturn bool
function Field:contains(point)
  assert(point:isInstanceOf(Point))

  local contains = self.cells[tostring(point)]
  return to_boolean(contains)
end

---
-- @tparam Point point
function Field:set(point)
  assert(point:isInstanceOf(Point))

  self.cells[tostring(point)] = true
end

---
-- @param operation func(point: Point, contains: bool): bool
-- @treturn Field
function Field:map(operation)
  assert(type(operation) == "function")

  local field = Field:new(self.size)
  for y = 0, self.size.height - 1 do
    for x = 0, self.size.width - 1 do
      local point = Point:new(x, y)
      local contains = self:contains(point)
      if operation(point, contains) then
        field:set(point)
      end
    end
  end

  return field
end

return Field
