local luaunit = require("luaunit")
local Point = require("lualife.point")

TestPoint = {}

function TestPoint:test_new()
  local point = Point:new(23, 42)
  
  luaunit.assertTrue(point:isInstanceOf(Point))

  luaunit.assertIsNumber(point.x)
  luaunit.assertEquals(point.x, 23)

  luaunit.assertIsNumber(point.y)
  luaunit.assertEquals(point.y, 42)
end

function TestPoint:test_tostring()
  local point = Point:new(23, 42)
  local text = tostring(point)

  luaunit.assertIsString(text)
  luaunit.assertEquals(text, "(23, 42)")
end

function TestPoint:test_translate()
  local point = Point:new(5, 12)
  local translated_point = point:translate(Point:new(23, 42))

  luaunit.assertTrue(translated_point:isInstanceOf(Point))
  luaunit.assertEquals(translated_point, Point:new(28, 54))
end 
