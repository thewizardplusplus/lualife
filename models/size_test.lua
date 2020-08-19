local luaunit = require("luaunit")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")

-- luacheck: globals TestSize
TestSize = {}

function TestSize.test_new()
  local size = Size:new(23, 42)

  luaunit.assert_true(size:isInstanceOf(Size))

  luaunit.assert_is_number(size.width)
  luaunit.assert_equals(size.width, 23)

  luaunit.assert_is_number(size.height)
  luaunit.assert_equals(size.height, 42)
end

function TestSize.test_tostring()
  local size = Size:new(23, 42)
  local text = tostring(size)

  luaunit.assert_is_string(text)
  luaunit.assert_equals(text, "{ 23, 42 }")
end

function TestSize.test_contains_false_top_left()
  local size = Size:new(23, 42)
  local contains = size:_contains(Point:new(-1, -1))

  luaunit.assert_is_boolean(contains)
  luaunit.assert_false(contains)
end

function TestSize.test_contains_false_bottom_right()
  local size = Size:new(23, 42)
  local contains = size:_contains(Point:new(23, 42))

  luaunit.assert_is_boolean(contains)
  luaunit.assert_false(contains)
end

function TestSize.test_contains_true_top_left()
  local size = Size:new(23, 42)
  local contains = size:_contains(Point:new(0, 0))

  luaunit.assert_is_boolean(contains)
  luaunit.assert_true(contains)
end

function TestSize.test_contains_true_bottom_right()
  local size = Size:new(23, 42)
  local contains = size:_contains(Point:new(22, 41))

  luaunit.assert_is_boolean(contains)
  luaunit.assert_true(contains)
end

function TestSize.test_fits_false_top_left()
  local size_one = Size:new(3, 3)
  local size_two = Size:new(10, 10)

  local fits = size_one:_fits(size_two, Point:new(-1, -1))

  luaunit.assert_is_boolean(fits)
  luaunit.assert_false(fits)
end

function TestSize.test_fits_false_bottom_right()
  local size_one = Size:new(3, 3)
  local size_two = Size:new(10, 10)

  local fits = size_one:_fits(size_two, Point:new(8, 8))

  luaunit.assert_is_boolean(fits)
  luaunit.assert_false(fits)
end

function TestSize.test_fits_true_top_left_full()
  local size_one = Size:new(3, 3)
  local size_two = Size:new(10, 10)

  local fits = size_one:_fits(size_two, Point:new(0, 0))

  luaunit.assert_is_boolean(fits)
  luaunit.assert_true(fits)
end

function TestSize.test_fits_true_top_left_partial()
  local size_one = Size:new(3, 3)
  local size_two = Size:new(10, 10)

  local fits = size_one:_fits(size_two)

  luaunit.assert_is_boolean(fits)
  luaunit.assert_true(fits)
end

function TestSize.test_fits_true_bottom_right()
  local size_one = Size:new(3, 3)
  local size_two = Size:new(10, 10)

  local fits = size_one:_fits(size_two, Point:new(7, 7))

  luaunit.assert_is_boolean(fits)
  luaunit.assert_true(fits)
end
