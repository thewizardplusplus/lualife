local script_file = arg[0]
local script_path = script_file:match(".*/")

local middleclass = require(
	 script_path
	   .. "vendor/middleclass/middleclass"
)

local Size = middleclass("Size")

function Size:initialize(width, height)
  self.width = width
  self.height = height
end

return Size
