local luaunit = require("luaunit")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local Field = require("lualife.models.field")

TestField = {}

function TestField:test_new()
  local size = Size:new(23, 42)
  local field = Field:new(size)
  
  luaunit.assert_true(field:isInstanceOf(Field))

  luaunit.assert_true(field.size:isInstanceOf(Size))
  luaunit.assert_is(field.size, size)

  luaunit.assert_is_table(field.cells)
  luaunit.assert_equals(field.cells, {})
end

function TestField:test_contains_false()
  local field = Field:new(Size:new(23, 42))
  field:set(Point:new(2, 3))
  field:set(Point:new(4, 2))

  local contains = field:contains(Point:new(1, 2))
  
  luaunit.assert_is_boolean(contains)
  luaunit.assert_false(contains)
end

function TestField:test_contains_true()
  local field = Field:new(Size:new(23, 42))
  field:set(Point:new(2, 3))
  field:set(Point:new(4, 2))

  local contains = field:contains(Point:new(2, 3))
  
  luaunit.assert_is_boolean(contains)
  luaunit.assert_true(contains)
end

function TestField:test_set()
  local field = Field:new(Size:new(23, 42))
  field:set(Point:new(2, 3))
  field:set(Point:new(4, 2))

  luaunit.assert_equals(field.cells, {
  	 ["(2, 3)"] = true,
  	 ["(4, 2)"] = true,
  })
end 
