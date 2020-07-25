local script_file = arg[0]
local script_path = script_file:match(".*/")

local middleclass = require(
	 script_path
	   .. "vendor/middleclass/middleclass"
)

local Size = require(script_path .. "size")
local Point = require(
  script_path .. "point"
)

local function to_boolean(value)
  return value and true or false
end

local Field = middleclass("Field")

function Field:initialize(size)
  assert(size:isInstanceOf(Size))

  self.size = size
  self.cells = {}
end

function Field:contains(point)
  assert(point:isInstanceOf(Point))

  local contains =
  	 self.cells[tostring(point)]
  return to_boolean(contains)
end

function Field:set(point)
  assert(point:isInstanceOf(Point))

  self.cells[tostring(point)] = true
end

return Field
