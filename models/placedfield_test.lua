local luaunit = require("luaunit")
local checks = require("luatypechecks.checks")
local assertions = require("luatypechecks.assertions")
local Vector2D = require("luamath.vector2d")
local Size = require("luamath.models.size")
local BoundingBox = require("luamath.models.boundingbox")
local Field = require("lualife.models.field")
local PlacedField = require("lualife.models.placedfield")

-- luacheck: globals TestPlacedField
TestPlacedField = {}

function TestPlacedField.test_place_full()
  local field = Field:new(Size:new(3, 3))
  field:set(Vector2D:new(0, 0))
  field:set(Vector2D:new(1, 0))
  field:set(Vector2D:new(0, 1))
  field:set(Vector2D:new(1, 1))

  local placed_field = PlacedField.place(field, Vector2D:new(23, 42))

  local want_placed_field =
    PlacedField:new(Size:new(3, 3), Vector2D:new(23, 42))
  want_placed_field:set(Vector2D:new(23, 42))
  want_placed_field:set(Vector2D:new(24, 42))
  want_placed_field:set(Vector2D:new(23, 43))
  want_placed_field:set(Vector2D:new(24, 43))

  luaunit.assert_true(checks.is_instance(placed_field, PlacedField))
  luaunit.assert_equals(placed_field, want_placed_field)
end

function TestPlacedField.test_place_partial()
  local field = Field:new(Size:new(3, 3))
  field:set(Vector2D:new(0, 0))
  field:set(Vector2D:new(1, 0))
  field:set(Vector2D:new(0, 1))
  field:set(Vector2D:new(1, 1))

  local placed_field = PlacedField.place(field)

  local want_placed_field = PlacedField:new(Size:new(3, 3))
  want_placed_field:set(Vector2D:new(0, 0))
  want_placed_field:set(Vector2D:new(1, 0))
  want_placed_field:set(Vector2D:new(0, 1))
  want_placed_field:set(Vector2D:new(1, 1))

  luaunit.assert_true(checks.is_instance(placed_field, PlacedField))
  luaunit.assert_equals(placed_field, want_placed_field)
end

function TestPlacedField.test_place_placed()
  local field = PlacedField:new(Size:new(3, 3), Vector2D:new(5, 12))
  field:set(Vector2D:new(5, 12))
  field:set(Vector2D:new(6, 12))
  field:set(Vector2D:new(5, 13))
  field:set(Vector2D:new(6, 13))

  local placed_field = PlacedField.place(field, Vector2D:new(23, 42))

  local want_placed_field =
    PlacedField:new(Size:new(3, 3), Vector2D:new(23, 42))
  want_placed_field:set(Vector2D:new(23, 42))
  want_placed_field:set(Vector2D:new(24, 42))
  want_placed_field:set(Vector2D:new(23, 43))
  want_placed_field:set(Vector2D:new(24, 43))

  luaunit.assert_true(checks.is_instance(placed_field, PlacedField))
  luaunit.assert_equals(placed_field, want_placed_field)
end

function TestPlacedField.test_new_full()
  local size = Size:new(5, 12)
  local offset = Vector2D:new(23, 42)
  local field = PlacedField:new(size, offset)

  luaunit.assert_true(checks.is_instance(field, PlacedField))

  luaunit.assert_true(checks.is_instance(field.size, Size))
  luaunit.assert_is(field.size, size)

  luaunit.assert_true(checks.is_instance(field.local_bounds, BoundingBox))
  luaunit.assert_equals(field.local_bounds, BoundingBox:new(
    Vector2D:new(0, 0),
    Vector2D:new(4, 11)
  ))

  luaunit.assert_true(checks.is_instance(field.bounds, BoundingBox))
  luaunit.assert_equals(field.bounds, BoundingBox:new(
    Vector2D:new(23, 42),
    Vector2D:new(27, 53)
  ))

  luaunit.assert_true(checks.is_instance(field.offset, Vector2D))
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

  luaunit.assert_true(checks.is_instance(field.local_bounds, BoundingBox))
  luaunit.assert_equals(field.local_bounds, BoundingBox:new(
    Vector2D:new(0, 0),
    Vector2D:new(4, 11)
  ))

  luaunit.assert_true(checks.is_instance(field.bounds, BoundingBox))
  luaunit.assert_equals(field.bounds, BoundingBox:new(
    Vector2D:new(0, 0),
    Vector2D:new(4, 11)
  ))

  luaunit.assert_true(checks.is_instance(field.offset, Vector2D))
  luaunit.assert_equals(field.offset, Vector2D:new(0, 0))

  luaunit.assert_is_table(field._cells)
  luaunit.assert_equals(field._cells, {})
end

function TestPlacedField.test_tostring_empty()
  local field = PlacedField:new(Size:new(5, 12), Vector2D:new(23, 42))
  local text = tostring(field)

  luaunit.assert_is_string(text)
  luaunit.assert_equals(text, "{" ..
    "__name = \"PlacedField\"," ..
    "bounds = {" ..
      "__name = \"BoundingBox\"," ..
      "max = {__name = \"Vector2D\",x = 27,y = 53}," ..
      "min = {__name = \"Vector2D\",x = 23,y = 42}" ..
    "}," ..
    "cells = {}," ..
    "local_bounds = {" ..
      "__name = \"BoundingBox\"," ..
      "max = {__name = \"Vector2D\",x = 4,y = 11}," ..
      "min = {__name = \"Vector2D\",x = 0,y = 0}" ..
    "}," ..
    "offset = {__name = \"Vector2D\",x = 23,y = 42}," ..
    "size = {__name = \"Size\",height = 12,width = 5}" ..
  "}")
end

function TestPlacedField.test_tostring_nonempty()
  local field = PlacedField:new(Size:new(5, 12), Vector2D:new(23, 42))
  field:set(Vector2D:new(25, 45))
  field:set(Vector2D:new(27, 44))

  local text = tostring(field)

  luaunit.assert_is_string(text)
  luaunit.assert_equals(text, "{" ..
    "__name = \"PlacedField\"," ..
    "bounds = {" ..
      "__name = \"BoundingBox\"," ..
      "max = {__name = \"Vector2D\",x = 27,y = 53}," ..
      "min = {__name = \"Vector2D\",x = 23,y = 42}" ..
    "}," ..
    "cells = { " ..
      "{__name = \"Vector2D\",x = 27,y = 44}, " ..
      "{__name = \"Vector2D\",x = 25,y = 45} " ..
    "}," ..
    "local_bounds = {" ..
      "__name = \"BoundingBox\"," ..
      "max = {__name = \"Vector2D\",x = 4,y = 11}," ..
      "min = {__name = \"Vector2D\",x = 0,y = 0}" ..
    "}," ..
    "offset = {__name = \"Vector2D\",x = 23,y = 42}," ..
    "size = {__name = \"Size\",height = 12,width = 5}" ..
  "}")
end

function TestPlacedField.test_contains_false()
  local field = PlacedField:new(Size:new(5, 12), Vector2D:new(23, 42))
  field:set(Vector2D:new(25, 45))
  field:set(Vector2D:new(27, 44))

  local contains = field:contains(Vector2D:new(24, 44))

  luaunit.assert_is_boolean(contains)
  luaunit.assert_false(contains)
end

function TestPlacedField.test_contains_true()
  local field = PlacedField:new(Size:new(5, 12), Vector2D:new(23, 42))
  field:set(Vector2D:new(25, 45))
  field:set(Vector2D:new(27, 44))

  local contains = field:contains(Vector2D:new(25, 45))

  luaunit.assert_is_boolean(contains)
  luaunit.assert_true(contains)
end

function TestPlacedField.test_fits_false_top_left()
  local field_one = PlacedField:new(Size:new(3, 3), Vector2D:new(1, 1))
  local field_two = PlacedField:new(Size:new(10, 10), Vector2D:new(2, 2))

  local fits = field_one:fits(field_two)

  luaunit.assert_is_boolean(fits)
  luaunit.assert_false(fits)
end

function TestPlacedField.test_fits_false_bottom_right()
  local field_one = PlacedField:new(Size:new(3, 3), Vector2D:new(10, 10))
  local field_two = PlacedField:new(Size:new(10, 10), Vector2D:new(2, 2))

  local fits = field_one:fits(field_two)

  luaunit.assert_is_boolean(fits)
  luaunit.assert_false(fits)
end

function TestPlacedField.test_fits_true_top_left()
  local field_one = PlacedField:new(Size:new(3, 3), Vector2D:new(2, 2))
  local field_two = PlacedField:new(Size:new(10, 10), Vector2D:new(2, 2))

  local fits = field_one:fits(field_two)

  luaunit.assert_is_boolean(fits)
  luaunit.assert_true(fits)
end

function TestPlacedField.test_fits_true_bottom_right()
  local field_one = PlacedField:new(Size:new(3, 3), Vector2D:new(9, 9))
  local field_two = PlacedField:new(Size:new(10, 10), Vector2D:new(2, 2))

  local fits = field_one:fits(field_two)

  luaunit.assert_is_boolean(fits)
  luaunit.assert_true(fits)
end

function TestPlacedField.test_set()
  local field = PlacedField:new(Size:new(5, 12), Vector2D:new(23, 42))
  field:set(Vector2D:new(25, 45))
  field:set(Vector2D:new(27, 44))

  luaunit.assert_equals(field._cells, {
    ["{__name = \"Vector2D\",x = 2,y = 3}"] = true,
    ["{__name = \"Vector2D\",x = 4,y = 2}"] = true,
  })
end

function TestPlacedField.test_map_point()
  local field = PlacedField:new(Size:new(3, 3), Vector2D:new(23, 42))
  field:set(Vector2D:new(23, 43))
  field:set(Vector2D:new(24, 43))
  field:set(Vector2D:new(25, 43))

  local next_field = field:map(function(point)
    assertions.is_instance(point, Vector2D)

    return point.x <= field.size.width / 2 + 23
      and point.y <= field.size.height / 2 + 42
  end)

  local want_next_field = PlacedField:new(Size:new(3, 3), Vector2D:new(23, 42))
  want_next_field:set(Vector2D:new(23, 42))
  want_next_field:set(Vector2D:new(24, 42))
  want_next_field:set(Vector2D:new(23, 43))
  want_next_field:set(Vector2D:new(24, 43))

  luaunit.assert_true(checks.is_instance(next_field, PlacedField))
  luaunit.assert_equals(next_field, want_next_field)
end

function TestPlacedField.test_map_contains()
  local field = PlacedField:new(Size:new(3, 3), Vector2D:new(23, 42))
  field:set(Vector2D:new(23, 43))
  field:set(Vector2D:new(24, 43))
  field:set(Vector2D:new(25, 43))

  local next_field = field:map(function(_, contains)
    assertions.is_boolean(contains)

    return not contains
  end)

  local want_next_field = PlacedField:new(Size:new(3, 3), Vector2D:new(23, 42))
  want_next_field:set(Vector2D:new(23, 42))
  want_next_field:set(Vector2D:new(24, 42))
  want_next_field:set(Vector2D:new(25, 42))
  want_next_field:set(Vector2D:new(23, 44))
  want_next_field:set(Vector2D:new(24, 44))
  want_next_field:set(Vector2D:new(25, 44))

  luaunit.assert_true(checks.is_instance(next_field, PlacedField))
  luaunit.assert_equals(next_field, want_next_field)
end
