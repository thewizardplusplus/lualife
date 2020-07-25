local scriptFile = arg[0]
local scriptPath = scriptFile:match '.*/'
local middleclass = require(
	 scriptPath
	   .. 'vendor/middleclass/middleclass'
)

local Size = middleclass('Size')

function Size:initialize(width, height)
  self.width = width
  self.height = height
end

return Size
