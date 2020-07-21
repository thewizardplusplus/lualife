local Point = {}

function Point:new(x, y)
  self.__index = self

  local point = {x = x, y = y}
  return setmetatable(point, self)
end

function Point:__tostring()
  return string.format(
  	 '(%d, %d)',
  	 self.x,
  	 self.y
  )
end

return Point
