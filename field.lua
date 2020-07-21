Field = {}

function Field:new()
  self.__index = self

  local field = {cells = {}}
  return setmetatable(field, self)
end

function Field:get(x, y)
  local cell = {x = x, y = y}
  return self.cells[cell]
end

function Field:set(x, y)
  local cell = {x = x, y = y}
  self.cells[cell] = true
end
