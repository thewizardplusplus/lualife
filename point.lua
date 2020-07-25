local scriptFile = arg[0]
local scriptPath = scriptFile:match '.*/'
local middleclass = require(
	 scriptPath
	   .. 'vendor/middleclass/middleclass'
)

local Point = middleclass('Point')

function Point:initialize(x, y)
  self.x = x
  self.y = y
end

function Point:__tostring()
  return string.format(
  	 '(%d, %d)',
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
