local function toBoolean(value)
  return value and true or false
end

local Field = {}

function Field:new(size)
  self.__index = self

  local field = {size = size, cells = {}}
  return setmetatable(field, self)
end

function Field:contains(point)
  local contains =
  	 self.cells[tostring(point)]
  return toBoolean(contains)
end

function Field:set(point)
  self.cells[tostring(point)] = true
end

return Field
