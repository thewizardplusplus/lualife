local script_file = arg[0]
local script_path = script_file:match(".*/")

local luaunit = require(
	 script_path .. "vendor/luaunit/luaunit"
)

local Point = require(
  script_path .. "point"
)

TestPoint = {}

function TestPoint:test_new()
  local point = Point:new(23, 42)

  luaunit.assertEquals(point.x, 23)
  luaunit.assertEquals(point.y, 42)
end

function TestPoint:test_tostring()
  local point = Point:new(23, 42)
  local text = tostring(point)

  luaunit.assertEquals("(23, 42)", text)
end

function TestPoint:test_translate()
  local point = Point:new(5, 12)
  local translated_point =
    point:translate(Point:new(23, 42))

  luaunit.assertEquals(
    translated_point,
    Point:new(28, 54)
  )
end 
