local luaunit = require("luaunit")
local Point = require("lualife.models.point")

TestPoint = {}

function TestPoint.test_new()
  local point = Point:new(23, 42)

  luaunit.assert_true(point:isInstanceOf(Point))

  luaunit.assert_is_number(point.x)
  luaunit.assert_equals(point.x, 23)

  luaunit.assert_is_number(point.y)
  luaunit.assert_equals(point.y, 42)
end

function TestPoint.test_tostring()
  local point = Point:new(23, 42)
  local text = tostring(point)

  luaunit.assert_is_string(text)
  luaunit.assert_equals(text, "(23, 42)")
end

function TestPoint.test_translate()
  local point = Point:new(5, 12)
  local translated_point = point:translate(Point:new(23, 42))

  luaunit.assert_true(translated_point:isInstanceOf(Point))
  luaunit.assert_equals(translated_point, Point:new(28, 54))
end
