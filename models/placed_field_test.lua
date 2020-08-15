local luaunit = require("luaunit")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local Field = require("lualife.models.field")
local PlacedField = require("lualife.models.placed_field")

-- luacheck: globals TestPlacedField
TestPlacedField = {}

function TestPlacedField.test_new_full()
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

function TestPlacedField.test_new_partial()
  local size = Size:new(5, 12)
  local field = PlacedField:new(size)

  luaunit.assert_true(field:isInstanceOf(PlacedField))

  luaunit.assert_true(field.size:isInstanceOf(Size))
  luaunit.assert_is(field.size, size)

  luaunit.assert_true(field.offset:isInstanceOf(Point))
  luaunit.assert_equals(field.offset, Point:new(0, 0))

  luaunit.assert_is_table(field.cells)
  luaunit.assert_equals(field.cells, {})
end

function TestPlacedField.test_contains_false()
  local field = PlacedField:new(Size:new(5, 12), Point:new(23, 42))
  field:set(Point:new(25, 45))
  field:set(Point:new(27, 44))

  local contains = field:contains(Point:new(24, 44))

  luaunit.assert_is_boolean(contains)
  luaunit.assert_false(contains)
end

function TestPlacedField.test_contains_true()
  local field = PlacedField:new(Size:new(5, 12), Point:new(23, 42))
  field:set(Point:new(25, 45))
  field:set(Point:new(27, 44))

  local contains = field:contains(Point:new(25, 45))

  luaunit.assert_is_boolean(contains)
  luaunit.assert_true(contains)
end

function TestPlacedField.test_set()
  local field = PlacedField:new(Size:new(5, 12), Point:new(23, 42))
  field:set(Point:new(25, 45))
  field:set(Point:new(27, 44))

  luaunit.assert_equals(field.cells, {
    ["(2, 3)"] = true,
    ["(4, 2)"] = true,
  })
end

function TestPlacedField.test_map_point()
  local field = PlacedField:new(Size:new(3, 3), Point:new(23, 42))
  field:set(Point:new(23, 43))
  field:set(Point:new(24, 43))
  field:set(Point:new(25, 43))

  local next_field = field:map(function(point)
    return point.x <= field.size.width / 2 + 23
      and point.y <= field.size.height / 2 + 42
  end)

  local want_next_field = Field:new(Size:new(3, 3))
  want_next_field:set(Point:new(0, 0))
  want_next_field:set(Point:new(1, 0))
  want_next_field:set(Point:new(0, 1))
  want_next_field:set(Point:new(1, 1))

  luaunit.assert_true(next_field:isInstanceOf(Field))
  luaunit.assert_equals(next_field, want_next_field)
end

function TestPlacedField.test_map_contains()
  local field = PlacedField:new(Size:new(3, 3), Point:new(23, 42))
  field:set(Point:new(23, 43))
  field:set(Point:new(24, 43))
  field:set(Point:new(25, 43))

  local next_field = field:map(function(_, contains)
    return not contains
  end)

  local want_next_field = Field:new(Size:new(3, 3))
  want_next_field:set(Point:new(0, 0))
  want_next_field:set(Point:new(1, 0))
  want_next_field:set(Point:new(2, 0))
  want_next_field:set(Point:new(0, 2))
  want_next_field:set(Point:new(1, 2))
  want_next_field:set(Point:new(2, 2))

  luaunit.assert_true(next_field:isInstanceOf(Field))
  luaunit.assert_equals(next_field, want_next_field)
end
