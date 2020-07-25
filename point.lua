local script_file = arg[0]
local script_path = script_file:match(".*/")

local middleclass = require(
	 script_path
	   .. "vendor/middleclass/middleclass"
)

local Point = middleclass("Point")

function Point:initialize(x, y)
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
  return Point:new(
  	 self.x + point.x,
  	 self.y + point.y
  )
end

return Point
