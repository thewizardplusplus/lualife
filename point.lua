local middleclass =
  require("vendor.middleclass.middleclass")

local Point = middleclass("Point")

function Point:initialize(x, y)
  assert(type(x) == "number")
  assert(type(y) == "number")

  self.x = x
  self.y = y
end

function Point:__tostring()
  return string.format(
  	 "(%d, %d)",
  	 self.x,
  	 self.y
  )
end

function Point:translate(point)
  assert(point:isInstanceOf(Point))

  return Point:new(
  	 self.x + point.x,
  	 self.y + point.y
  )
end

return Point
