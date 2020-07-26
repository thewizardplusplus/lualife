local luaunit =
  require("vendor.luaunit.luaunit")
local Size = require("size")
local Point = require("point")
local Field = require("field")

TestField = {}

function TestField:test_new()
  local size = Size:new(23, 42)
  local field = Field:new(size)

  luaunit.assertEquals(field.size, size)
  luaunit.assertEquals(field.cells, {})
end

function TestField:test_contains()
  local size = Size:new(23, 42)
  local field = Field:new(size)
  field:set(Point:new(2, 3))
  field:set(Point:new(4, 2))

  local point =
    field:contains(Point:new(2, 3))
  luaunit.assertEquals(point, true)

  local missed_point =
    field:contains(Point:new(1, 2))
  luaunit.assertEquals(missed_point, false)
end

function TestField:test_set()
  local size = Size:new(23, 42)
  local field = Field:new(size)
  field:set(Point:new(2, 3))
  field:set(Point:new(4, 2))

  luaunit.assertEquals(field.cells, {
  	 ["(2, 3)"] = true,
  	 ["(4, 2)"] = true,
  })
end 
