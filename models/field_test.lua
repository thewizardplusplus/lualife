local luaunit = require("luaunit")
local checks = require("luatypechecks.checks")
local assertions = require("luatypechecks.assertions")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local Field = require("lualife.models.field")

-- luacheck: globals TestField
TestField = {}

function TestField.test_new()
  local size = Size:new(23, 42)
  local field = Field:new(size)

  luaunit.assert_true(checks.is_instance(field, Field))

  luaunit.assert_true(checks.is_instance(field.size, Size))
  luaunit.assert_is(field.size, size)

  luaunit.assert_is_table(field._cells)
  luaunit.assert_equals(field._cells, {})
end

function TestField.test_tostring_empty()
  local field = Field:new(Size:new(23, 42))
  local text = tostring(field)

  luaunit.assert_is_string(text)
  luaunit.assert_equals(text, "{" ..
    "cells = {}," ..
    "size = {height = 42,width = 23}" ..
  "}")
end

function TestField.test_tostring_nonempty()
  local field = Field:new(Size:new(23, 42))
  field:set(Point:new(2, 3))
  field:set(Point:new(4, 2))

  local text = tostring(field)

  luaunit.assert_is_string(text)
  luaunit.assert_equals(text, "{" ..
    "cells = { {x = 4,y = 2}, {x = 2,y = 3} }," ..
    "size = {height = 42,width = 23}" ..
  "}")
end

function TestField.test_count_empty()
  local field = Field:new(Size:new(23, 42))
  local count = field:count()

  luaunit.assert_is_number(count)
  luaunit.assert_equals(count, 0)
end

function TestField.test_count_nonempty()
  local field = Field:new(Size:new(23, 42))
  field:set(Point:new(2, 3))
  field:set(Point:new(4, 2))

  local count = field:count()

  luaunit.assert_is_number(count)
  luaunit.assert_equals(count, 2)
end

function TestField.test_contains_false_inside()
  local field = Field:new(Size:new(23, 42))
  field:set(Point:new(2, 3))
  field:set(Point:new(4, 2))

  local contains = field:contains(Point:new(1, 2))

  luaunit.assert_is_boolean(contains)
  luaunit.assert_false(contains)
end

function TestField.test_contains_false_outside()
  local field = Field:new(Size:new(23, 42))
  field._cells = {
    ["{__name = \"Point\",x = 2,y = 3}"] = true,
    ["{__name = \"Point\",x = 100,y = 100}"] = true,
  }

  local contains = field:contains(Point:new(100, 100))

  luaunit.assert_is_boolean(contains)
  luaunit.assert_false(contains)
end

function TestField.test_contains_true()
  local field = Field:new(Size:new(23, 42))
  field:set(Point:new(2, 3))
  field:set(Point:new(4, 2))

  local contains = field:contains(Point:new(2, 3))

  luaunit.assert_is_boolean(contains)
  luaunit.assert_true(contains)
end

function TestField.test_fits_false()
  local field_one = Field:new(Size:new(30, 30))
  local field_two = Field:new(Size:new(10, 10))

  local fits = field_one:fits(field_two)

  luaunit.assert_is_boolean(fits)
  luaunit.assert_false(fits)
end

function TestField.test_fits_true()
  local field_one = Field:new(Size:new(3, 3))
  local field_two = Field:new(Size:new(10, 10))

  local fits = field_one:fits(field_two)

  luaunit.assert_is_boolean(fits)
  luaunit.assert_true(fits)
end

function TestField.test_set_inside()
  local field = Field:new(Size:new(23, 42))
  field:set(Point:new(2, 3))
  field:set(Point:new(4, 2))

  luaunit.assert_equals(field._cells, {
    ["{__name = \"Point\",x = 2,y = 3}"] = true,
    ["{__name = \"Point\",x = 4,y = 2}"] = true,
  })
end

function TestField.test_set_outside()
  local field = Field:new(Size:new(23, 42))
  field:set(Point:new(2, 3))
  field:set(Point:new(100, 100))

  luaunit.assert_equals(field._cells, {
    ["{__name = \"Point\",x = 2,y = 3}"] = true,
  })
end

function TestField.test_map_point()
  local field = Field:new(Size:new(3, 3))
  field:set(Point:new(0, 1))
  field:set(Point:new(1, 1))
  field:set(Point:new(2, 1))

  local next_field = field:map(function(point)
    assertions.is_instance(point, Point)

    return point.x <= field.size.width / 2
      and point.y <= field.size.height / 2
  end)

  local want_next_field = Field:new(Size:new(3, 3))
  want_next_field:set(Point:new(0, 0))
  want_next_field:set(Point:new(1, 0))
  want_next_field:set(Point:new(0, 1))
  want_next_field:set(Point:new(1, 1))

  luaunit.assert_true(checks.is_instance(next_field, Field))
  luaunit.assert_equals(next_field, want_next_field)
end

function TestField.test_map_contains()
  local field = Field:new(Size:new(3, 3))
  field:set(Point:new(0, 1))
  field:set(Point:new(1, 1))
  field:set(Point:new(2, 1))

  local next_field = field:map(function(_, contains)
    assertions.is_boolean(contains)

    return not contains
  end)

  local want_next_field = Field:new(Size:new(3, 3))
  want_next_field:set(Point:new(0, 0))
  want_next_field:set(Point:new(1, 0))
  want_next_field:set(Point:new(2, 0))
  want_next_field:set(Point:new(0, 2))
  want_next_field:set(Point:new(1, 2))
  want_next_field:set(Point:new(2, 2))

  luaunit.assert_true(checks.is_instance(next_field, Field))
  luaunit.assert_equals(next_field, want_next_field)
end
