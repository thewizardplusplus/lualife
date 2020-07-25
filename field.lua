local script_file = arg[0]
local script_path = script_file:match(".*/")

local middleclass = require(
	 script_path
	   .. "vendor/middleclass/middleclass"
)

local function to_boolean(value)
  return value and true or false
end

local Field = middleclass("Field")

function Field:initialize(size)
  self.size = size
  self.cells = {}
end

function Field:contains(point)
  local contains =
  	 self.cells[tostring(point)]
  return to_boolean(contains)
end

function Field:set(point)
  self.cells[tostring(point)] = true
end

return Field
