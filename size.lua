local Size = {}

function Size:new(width, height)
  self.__index = self

  local size = {
    width = width,
    height = height,
  }
  return setmetatable(size, self)
end

return Size
