local luaunit = require("luaunit")
local checks = require("luatypechecks.checks")
local assertions = require("luatypechecks.assertions")
local json = require("luaserialization.json")
local Vector2D = require("luamath.vector2d")
local Size = require("luamath.models.size")
local BoundingBox = require("luamath.models.boundingbox")
local Field = require("lualife.models.field")

-- luacheck: globals TestField
TestField = {}

function TestField.test_from_json_success()
  local field, err = json.from_json(
    [=[{
      "__name": "Field",
      "size": {"__name": "Size", "width": 3, "height": 3},
      "bounds": {
        "__name": "BoundingBox",
        "min": {"__name": "Vector2D", "x": 0, "y": 0},
        "max": {"__name": "Vector2D", "x": 2, "y": 2}
      },
      "cells": [
        {"__name": "Vector2D", "x": 0, "y": 1},
        {"__name": "Vector2D", "x": 2, "y": 1}
      ]
    }]=],
    Field.schema(),
    {
      Vector2D = Vector2D.from_options,
      Size = Size.from_options,
      BoundingBox = BoundingBox.from_options,
      Field = Field.from_options,
    }
  )

  luaunit.assert_true(checks.is_instance(field, Field))

  luaunit.assert_true(checks.is_instance(field.size, Size))
  luaunit.assert_is(field.size, Size:new(3, 3))

  luaunit.assert_true(checks.is_instance(field.bounds, BoundingBox))
  luaunit.assert_equals(field.bounds, BoundingBox:new(
    Vector2D:new(0, 0),
    Vector2D:new(2, 2)
  ))

  luaunit.assert_is_table(field._cells)
  luaunit.assert_equals(field._cells, {
    ["{__name = \"Vector2D\",x = 0,y = 1}"] = true,
    ["{__name = \"Vector2D\",x = 2,y = 1}"] = true,
  })

  luaunit.assert_nil(err)
end

function TestField.test_from_json_error()
  local field, err = json.from_json(
    [=[{
      "__name": "Field",
      "size": {"__name": "Size", "width": 3, "height": 3},
      "bounds": {
        "__name": "BoundingBox",
        "min": {"__name": "Vector2D", "x": 0, "y": 0},
        "max": {"__name": "Vector2D", "x": 2, "y": 2}
      },
      "cells": [
        {"__name": "Vector2D", "x": "invalid", "y": 1},
        {"__name": "Vector2D", "x": 2, "y": 1}
      ]
    }]=],
    Field.schema(),
    {
      Vector2D = Vector2D.from_options,
      Size = Size.from_options,
      BoundingBox = BoundingBox.from_options,
      Field = Field.from_options,
    }
  )

  luaunit.assert_nil(field)

  luaunit.assert_is_string(err)
  luaunit.assert_str_matches(
    err,
    "^invalid data: " ..
      [[property "cells" validation failed: ]] ..
      "failed to validate item 1: " ..
      [[property "x" validation failed: ]] ..
      "wrong type: " ..
      "expected number, got string$"
  )
end

function TestField.test_from_options_copies_inputs()
  local options = {
    size = Size:new(3, 3),
    cells = {Vector2D:new(0, 1), Vector2D:new(2, 1)},
  }
  local field = Field.from_options(options)

  options.size.height = 4
  options.cells[1].y = 2
  options.cells[2] = Vector2D:new(1, 2)

  local want_field = Field:new(Size:new(3, 3))
  want_field:set(Vector2D:new(0, 1))
  want_field:set(Vector2D:new(2, 1))

  luaunit.assert_equals(field, want_field)
end

function TestField.test_new()
  local size = Size:new(23, 42)
  local field = Field:new(size)

  luaunit.assert_true(checks.is_instance(field, Field))

  luaunit.assert_true(checks.is_instance(field.size, Size))
  luaunit.assert_is(field.size, size)

  luaunit.assert_true(checks.is_instance(field.bounds, BoundingBox))
  luaunit.assert_equals(field.bounds, BoundingBox:new(
    Vector2D:new(0, 0),
    Vector2D:new(22, 41)
  ))

  luaunit.assert_is_table(field._cells)
  luaunit.assert_equals(field._cells, {})
end

function TestField.test_new_copies_inputs()
  local size = Size:new(23, 42)
  local field = Field:new(size)

  size.height = 50

  luaunit.assert_equals(field.size, Size:new(23, 42))
  luaunit.assert_equals(field.bounds, BoundingBox:new(
    Vector2D:new(0, 0),
    Vector2D:new(22, 41)
  ))
end

function TestField.test_tostring_empty()
  local field = Field:new(Size:new(23, 42))
  local text = tostring(field)

  luaunit.assert_is_string(text)
  luaunit.assert_equals(text, "{" ..
    "__name = \"Field\"," ..
    "bounds = {" ..
      "__name = \"BoundingBox\"," ..
      "max = {__name = \"Vector2D\",x = 22,y = 41}," ..
      "min = {__name = \"Vector2D\",x = 0,y = 0}" ..
    "}," ..
    "cells = {}," ..
    "size = {__name = \"Size\",height = 42,width = 23}" ..
  "}")
end

function TestField.test_tostring_nonempty()
  local field = Field:new(Size:new(23, 42))
  field:set(Vector2D:new(2, 3))
  field:set(Vector2D:new(4, 2))

  local text = tostring(field)

  luaunit.assert_is_string(text)
  luaunit.assert_equals(text, "{" ..
    "__name = \"Field\"," ..
    "bounds = {" ..
      "__name = \"BoundingBox\"," ..
      "max = {__name = \"Vector2D\",x = 22,y = 41}," ..
      "min = {__name = \"Vector2D\",x = 0,y = 0}" ..
    "}," ..
    "cells = { " ..
      "{__name = \"Vector2D\",x = 4,y = 2}, " ..
      "{__name = \"Vector2D\",x = 2,y = 3} " ..
    "}," ..
    "size = {__name = \"Size\",height = 42,width = 23}" ..
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
  field:set(Vector2D:new(2, 3))
  field:set(Vector2D:new(4, 2))

  local count = field:count()

  luaunit.assert_is_number(count)
  luaunit.assert_equals(count, 2)
end

function TestField.test_contains_false_inside()
  local field = Field:new(Size:new(23, 42))
  field:set(Vector2D:new(2, 3))
  field:set(Vector2D:new(4, 2))

  local contains = field:contains(Vector2D:new(1, 2))

  luaunit.assert_is_boolean(contains)
  luaunit.assert_false(contains)
end

function TestField.test_contains_false_outside()
  local field = Field:new(Size:new(23, 42))
  field._cells = {
    ["{__name = \"Vector2D\",x = 2,y = 3}"] = true,
    ["{__name = \"Vector2D\",x = 100,y = 100}"] = true,
  }

  local contains = field:contains(Vector2D:new(100, 100))

  luaunit.assert_is_boolean(contains)
  luaunit.assert_false(contains)
end

function TestField.test_contains_true()
  local field = Field:new(Size:new(23, 42))
  field:set(Vector2D:new(2, 3))
  field:set(Vector2D:new(4, 2))

  local contains = field:contains(Vector2D:new(2, 3))

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
  field:set(Vector2D:new(2, 3))
  field:set(Vector2D:new(4, 2))

  luaunit.assert_equals(field._cells, {
    ["{__name = \"Vector2D\",x = 2,y = 3}"] = true,
    ["{__name = \"Vector2D\",x = 4,y = 2}"] = true,
  })
end

function TestField.test_set_outside()
  local field = Field:new(Size:new(23, 42))
  field:set(Vector2D:new(2, 3))
  field:set(Vector2D:new(100, 100))

  luaunit.assert_equals(field._cells, {
    ["{__name = \"Vector2D\",x = 2,y = 3}"] = true,
  })
end

function TestField.test_map_point()
  local field = Field:new(Size:new(3, 3))
  field:set(Vector2D:new(0, 1))
  field:set(Vector2D:new(1, 1))
  field:set(Vector2D:new(2, 1))

  local next_field = field:map(function(point)
    assertions.is_instance(point, Vector2D)

    return point.x <= field.size.width / 2
      and point.y <= field.size.height / 2
  end)

  local want_next_field = Field:new(Size:new(3, 3))
  want_next_field:set(Vector2D:new(0, 0))
  want_next_field:set(Vector2D:new(1, 0))
  want_next_field:set(Vector2D:new(0, 1))
  want_next_field:set(Vector2D:new(1, 1))

  luaunit.assert_true(checks.is_instance(next_field, Field))
  luaunit.assert_equals(next_field, want_next_field)
end

function TestField.test_map_contains()
  local field = Field:new(Size:new(3, 3))
  field:set(Vector2D:new(0, 1))
  field:set(Vector2D:new(1, 1))
  field:set(Vector2D:new(2, 1))

  local next_field = field:map(function(_, contains)
    assertions.is_boolean(contains)

    return not contains
  end)

  local want_next_field = Field:new(Size:new(3, 3))
  want_next_field:set(Vector2D:new(0, 0))
  want_next_field:set(Vector2D:new(1, 0))
  want_next_field:set(Vector2D:new(2, 0))
  want_next_field:set(Vector2D:new(0, 2))
  want_next_field:set(Vector2D:new(1, 2))
  want_next_field:set(Vector2D:new(2, 2))

  luaunit.assert_true(checks.is_instance(next_field, Field))
  luaunit.assert_equals(next_field, want_next_field)
end

function TestField.test_map_copies_inputs()
  local field = Field:new(Size:new(3, 3))
  field:set(Vector2D:new(1, 1))
  field:set(Vector2D:new(2, 1))

  local next_field = field:map(function(_, contains)
    assertions.is_boolean(contains)

    return contains
  end)

  field.size.height = 4
  field:set(Vector2D:new(2, 2))

  local want_next_field = Field:new(Size:new(3, 3))
  want_next_field:set(Vector2D:new(1, 1))
  want_next_field:set(Vector2D:new(2, 1))

  luaunit.assert_equals(next_field, want_next_field)
end
