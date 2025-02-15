local luaunit = require("luaunit")
local checks = require("luatypechecks.checks")
local assertions = require("luatypechecks.assertions")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local Field = require("lualife.models.field")
local PlacedField = require("lualife.models.placedfield")

-- luacheck: globals TestPlacedField
TestPlacedField = {}

function TestPlacedField.test_place_full()
  local field = Field:new(Size:new(3, 3))
  field:set(Point:new(0, 0))
  field:set(Point:new(1, 0))
  field:set(Point:new(0, 1))
  field:set(Point:new(1, 1))

  local placed_field = PlacedField.place(field, Point:new(23, 42))

  local want_placed_field = PlacedField:new(Size:new(3, 3), Point:new(23, 42))
  want_placed_field:set(Point:new(23, 42))
  want_placed_field:set(Point:new(24, 42))
  want_placed_field:set(Point:new(23, 43))
  want_placed_field:set(Point:new(24, 43))

  luaunit.assert_true(checks.is_instance(placed_field, PlacedField))
  luaunit.assert_equals(placed_field, want_placed_field)
end

function TestPlacedField.test_place_partial()
  local field = Field:new(Size:new(3, 3))
  field:set(Point:new(0, 0))
  field:set(Point:new(1, 0))
  field:set(Point:new(0, 1))
  field:set(Point:new(1, 1))

  local placed_field = PlacedField.place(field)

  local want_placed_field = PlacedField:new(Size:new(3, 3))
  want_placed_field:set(Point:new(0, 0))
  want_placed_field:set(Point:new(1, 0))
  want_placed_field:set(Point:new(0, 1))
  want_placed_field:set(Point:new(1, 1))

  luaunit.assert_true(checks.is_instance(placed_field, PlacedField))
  luaunit.assert_equals(placed_field, want_placed_field)
end

function TestPlacedField.test_place_placed()
  local field = PlacedField:new(Size:new(3, 3), Point:new(5, 12))
  field:set(Point:new(5, 12))
  field:set(Point:new(6, 12))
  field:set(Point:new(5, 13))
  field:set(Point:new(6, 13))

  local placed_field = PlacedField.place(field, Point:new(23, 42))

  local want_placed_field = PlacedField:new(Size:new(3, 3), Point:new(23, 42))
  want_placed_field:set(Point:new(23, 42))
  want_placed_field:set(Point:new(24, 42))
  want_placed_field:set(Point:new(23, 43))
  want_placed_field:set(Point:new(24, 43))

  luaunit.assert_true(checks.is_instance(placed_field, PlacedField))
  luaunit.assert_equals(placed_field, want_placed_field)
end

function TestPlacedField.test_new_full()
  local size = Size:new(5, 12)
  local offset = Point:new(23, 42)
  local field = PlacedField:new(size, offset)

  luaunit.assert_true(checks.is_instance(field, PlacedField))

  luaunit.assert_true(checks.is_instance(field.size, Size))
  luaunit.assert_is(field.size, size)

  luaunit.assert_true(checks.is_instance(field.offset, Point))
  luaunit.assert_is(field.offset, offset)

  luaunit.assert_is_table(field._cells)
  luaunit.assert_equals(field._cells, {})
end

function TestPlacedField.test_new_partial()
  local size = Size:new(5, 12)
  local field = PlacedField:new(size)

  luaunit.assert_true(checks.is_instance(field, PlacedField))

  luaunit.assert_true(checks.is_instance(field.size, Size))
  luaunit.assert_is(field.size, size)

  luaunit.assert_true(checks.is_instance(field.offset, Point))
  luaunit.assert_equals(field.offset, Point:new(0, 0))

  luaunit.assert_is_table(field._cells)
  luaunit.assert_equals(field._cells, {})
end

function TestPlacedField.test_tostring_empty()
  local field = PlacedField:new(Size:new(5, 12), Point:new(23, 42))
  local text = tostring(field)

  luaunit.assert_is_string(text)
  luaunit.assert_equals(text, "{" ..
    "__name = \"PlacedField\"," ..
    "cells = {}," ..
    "offset = {__name = \"Point\",x = 23,y = 42}," ..
    "size = {__name = \"Size\",height = 12,width = 5}" ..
  "}")
end

function TestPlacedField.test_tostring_nonempty()
  local field = PlacedField:new(Size:new(5, 12), Point:new(23, 42))
  field:set(Point:new(25, 45))
  field:set(Point:new(27, 44))

  local text = tostring(field)

  luaunit.assert_is_string(text)
  luaunit.assert_equals(text, "{" ..
    "__name = \"PlacedField\"," ..
    "cells = { " ..
      "{__name = \"Point\",x = 27,y = 44}, " ..
      "{__name = \"Point\",x = 25,y = 45} " ..
    "}," ..
    "offset = {__name = \"Point\",x = 23,y = 42}," ..
    "size = {__name = \"Size\",height = 12,width = 5}" ..
  "}")
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

function TestPlacedField.test_fits_false_top_left()
  local field_one = PlacedField:new(Size:new(3, 3), Point:new(1, 1))
  local field_two = PlacedField:new(Size:new(10, 10), Point:new(2, 2))

  local fits = field_one:fits(field_two)

  luaunit.assert_is_boolean(fits)
  luaunit.assert_false(fits)
end

function TestPlacedField.test_fits_false_bottom_right()
  local field_one = PlacedField:new(Size:new(3, 3), Point:new(10, 10))
  local field_two = PlacedField:new(Size:new(10, 10), Point:new(2, 2))

  local fits = field_one:fits(field_two)

  luaunit.assert_is_boolean(fits)
  luaunit.assert_false(fits)
end

function TestPlacedField.test_fits_true_top_left()
  local field_one = PlacedField:new(Size:new(3, 3), Point:new(2, 2))
  local field_two = PlacedField:new(Size:new(10, 10), Point:new(2, 2))

  local fits = field_one:fits(field_two)

  luaunit.assert_is_boolean(fits)
  luaunit.assert_true(fits)
end

function TestPlacedField.test_fits_true_bottom_right()
  local field_one = PlacedField:new(Size:new(3, 3), Point:new(9, 9))
  local field_two = PlacedField:new(Size:new(10, 10), Point:new(2, 2))

  local fits = field_one:fits(field_two)

  luaunit.assert_is_boolean(fits)
  luaunit.assert_true(fits)
end

function TestPlacedField.test_set()
  local field = PlacedField:new(Size:new(5, 12), Point:new(23, 42))
  field:set(Point:new(25, 45))
  field:set(Point:new(27, 44))

  luaunit.assert_equals(field._cells, {
    ["{__name = \"Point\",x = 2,y = 3}"] = true,
    ["{__name = \"Point\",x = 4,y = 2}"] = true,
  })
end

function TestPlacedField.test_map_point()
  local field = PlacedField:new(Size:new(3, 3), Point:new(23, 42))
  field:set(Point:new(23, 43))
  field:set(Point:new(24, 43))
  field:set(Point:new(25, 43))

  local next_field = field:map(function(point)
    assertions.is_instance(point, Point)

    return point.x <= field.size.width / 2 + 23
      and point.y <= field.size.height / 2 + 42
  end)

  local want_next_field = PlacedField:new(Size:new(3, 3), Point:new(23, 42))
  want_next_field:set(Point:new(23, 42))
  want_next_field:set(Point:new(24, 42))
  want_next_field:set(Point:new(23, 43))
  want_next_field:set(Point:new(24, 43))

  luaunit.assert_true(checks.is_instance(next_field, PlacedField))
  luaunit.assert_equals(next_field, want_next_field)
end

function TestPlacedField.test_map_contains()
  local field = PlacedField:new(Size:new(3, 3), Point:new(23, 42))
  field:set(Point:new(23, 43))
  field:set(Point:new(24, 43))
  field:set(Point:new(25, 43))

  local next_field = field:map(function(_, contains)
    assertions.is_boolean(contains)

    return not contains
  end)

  local want_next_field = PlacedField:new(Size:new(3, 3), Point:new(23, 42))
  want_next_field:set(Point:new(23, 42))
  want_next_field:set(Point:new(24, 42))
  want_next_field:set(Point:new(25, 42))
  want_next_field:set(Point:new(23, 44))
  want_next_field:set(Point:new(24, 44))
  want_next_field:set(Point:new(25, 44))

  luaunit.assert_true(checks.is_instance(next_field, PlacedField))
  luaunit.assert_equals(next_field, want_next_field)
end
