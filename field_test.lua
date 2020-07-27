local luaunit = require("luaunit")
local Size = require("lualife.size")
local Point = require("lualife.point")
local Field = require("lualife.field")

TestField = {}

function TestField:test_new()
  local size = Size:new(23, 42)
  local field = Field:new(size)
  
  luaunit.assertTrue(field:isInstanceOf(Field))

  luaunit.assertTrue(field.size:isInstanceOf(Size))
  luaunit.assertIs(field.size, size)

  luaunit.assertIsTable(field.cells)
  luaunit.assertEquals(field.cells, {})
end

function TestField:test_contains_false()
  local field = Field:new(Size:new(23, 42))
  field:set(Point:new(2, 3))
  field:set(Point:new(4, 2))

  local contains = field:contains(Point:new(1, 2))
  
  luaunit.assertIsBoolean(contains)
  luaunit.assertFalse(contains)
end

function TestField:test_contains_true()
  local field = Field:new(Size:new(23, 42))
  field:set(Point:new(2, 3))
  field:set(Point:new(4, 2))

  local contains = field:contains(Point:new(2, 3))
  
  luaunit.assertIsBoolean(contains)
  luaunit.assertTrue(contains)
end

function TestField:test_set()
  local field = Field:new(Size:new(23, 42))
  field:set(Point:new(2, 3))
  field:set(Point:new(4, 2))

  luaunit.assertEquals(field.cells, {
  	 ["(2, 3)"] = true,
  	 ["(4, 2)"] = true,
  })
end 
