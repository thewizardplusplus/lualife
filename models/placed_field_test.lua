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
