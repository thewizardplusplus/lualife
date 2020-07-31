local luaunit = require("luaunit")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local Field = require("lualife.models.field")

-- luacheck: globals TestField
TestField = {}

function TestField.test_new()
  local size = Size:new(23, 42)
  local field = Field:new(size)

  luaunit.assert_true(field:isInstanceOf(Field))

  luaunit.assert_true(field.size:isInstanceOf(Size))
  luaunit.assert_is(field.size, size)

  luaunit.assert_is_table(field.cells)
  luaunit.assert_equals(field.cells, {})
end

function TestField.test_contains_false()
  local field = Field:new(Size:new(23, 42))
  field:set(Point:new(2, 3))
  field:set(Point:new(4, 2))

  local contains = field:contains(Point:new(1, 2))

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

function TestField.test_set()
  local field = Field:new(Size:new(23, 42))
  field:set(Point:new(2, 3))
  field:set(Point:new(4, 2))

  luaunit.assert_equals(field.cells, {
    ["(2, 3)"] = true,
    ["(4, 2)"] = true,
  })
end

function TestField.test_map_point()
  local field = Field:new(Size:new(3, 3))
  field:set(Point:new(0, 1))
  field:set(Point:new(1, 1))
  field:set(Point:new(2, 1))

  local next_field = field:map(function(point, contains)
    return point.x <= field.size.width / 2
      and point.y <= field.size.height / 2
  end)

  local want_next_field = Field:new(Size:new(3, 3))
  want_next_field:set(Point:new(0, 0))
  want_next_field:set(Point:new(1, 0))
  want_next_field:set(Point:new(0, 1))
  want_next_field:set(Point:new(1, 1))

  luaunit.assert_true(next_field:isInstanceOf(Field))
  luaunit.assert_equals(next_field, want_next_field)
end

function TestField.test_map_contains()
  local field = Field:new(Size:new(3, 3))
  field:set(Point:new(0, 1))
  field:set(Point:new(1, 1))
  field:set(Point:new(2, 1))

  local next_field = field:map(function(point, contains)
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
