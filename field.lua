local scriptFile = arg[0]
local scriptPath = scriptFile:match '.*/'
local middleclass = require(
	 scriptPath
	   .. 'vendor/middleclass/middleclass'
)

local function toBoolean(value)
  return value and true or false
end

local Field = middleclass('Field')

function Field:initialize(size)
  self.size = size
  self.cells = {}
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
