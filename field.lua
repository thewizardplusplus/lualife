local function toBoolean(value)
  return value and true or false
end

local Field = {}

function Field:new()
  self.__index = self

  local field = {cells = {}}
  return setmetatable(field, self)
end

function Field:isContains(point)
  local isContains =
  	 self.cells[tostring(point)]
  return toBoolean(isContains)
end

function Field:set(point)
  self.cells[tostring(point)] = true
end

return Field
