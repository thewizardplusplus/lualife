local luaunit = require("luaunit")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local PlacedField = require("lualife.models.placed_field")

-- luacheck: globals TestPlacedField
TestPlacedField = {}

function TestPlacedField.test_new()
  local size = Size:new(5, 12)
  local offset = Point:new(23, 42)
  local field = PlacedField:new(size, offset)

  luaunit.assert_true(field:isInstanceOf(PlacedField))

  luaunit.assert_true(field.size:isInstanceOf(Size))
  luaunit.assert_is(field.size, size)

  luaunit.assert_true(field.offset:isInstanceOf(Point))
  luaunit.assert_is(field.offset, offset)

  luaunit.assert_is_table(field.cells)
  luaunit.assert_equals(field.cells, {})
end

function TestPlacedField.test_contains_false()
  local field = PlacedField:new(Size:new(5, 12), Point:new(23, 42))
  field:set(Point:new(2, 3))
  field:set(Point:new(4, 2))

  local contains = field:contains(Point:new(24, 44))

  luaunit.assert_is_boolean(contains)
  luaunit.assert_false(contains)
end

function TestPlacedField.test_contains_true()
  local field = PlacedField:new(Size:new(5, 12), Point:new(23, 42))
  field:set(Point:new(2, 3))
  field:set(Point:new(4, 2))

  local contains = field:contains(Point:new(25, 45))

  luaunit.assert_is_boolean(contains)
  luaunit.assert_true(contains)
end
