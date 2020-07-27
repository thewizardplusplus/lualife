local luaunit = require("luaunit")
local Size = require("lualife.size")
local Point = require("lualife.point")
local Field = require("lualife.field")
local life = require("lualife.life")

TestNeighbors = {}

function TestNeighbors:test()
  local field = Field:new(Size:new(3, 3))
  field:set(Point:new(0, 0))
  field:set(Point:new(1, 0))
  field:set(Point:new(0, 1))
  field:set(Point:new(1, 1))

  local neighbors =
    life.neighbors(field, Point:new(1, 1))

  luaunit.assertEquals(neighbors, 3)
end

TestPopulate = {}

function TestPopulate:test_blinker()
  local field = Field:new(Size:new(3, 3))
  field:set(Point:new(0, 1))
  field:set(Point:new(1, 1))
  field:set(Point:new(2, 1))

  local next_field = life.populate(field)

  local want_next_field =
    Field:new(Size:new(3, 3))
  want_next_field:set(Point:new(1, 0))
  want_next_field:set(Point:new(1, 1))
  want_next_field:set(Point:new(1, 2))

  luaunit.assertEquals(
    next_field,
    want_next_field
  )
end

function TestPopulate:test_glider_full()
  local field = Field:new(Size:new(4, 4))
  field:set(Point:new(1, 0))
  field:set(Point:new(2, 1))
  field:set(Point:new(0, 2))
  field:set(Point:new(1, 2))
  field:set(Point:new(2, 2))

  local next_field = life.populate(field)

  local want_next_field =
    Field:new(Size:new(4, 4))
  want_next_field:set(Point:new(0, 1))
  want_next_field:set(Point:new(2, 1))
  want_next_field:set(Point:new(1, 2))
  want_next_field:set(Point:new(2, 2))
  want_next_field:set(Point:new(1, 3))

  luaunit.assertEquals(
    next_field,
    want_next_field
  )
end

function TestPopulate:test_glider_partial()
  local field = Field:new(Size:new(3, 3))
  field:set(Point:new(1, 0))
  field:set(Point:new(2, 1))
  field:set(Point:new(0, 2))
  field:set(Point:new(1, 2))
  field:set(Point:new(2, 2))

  local next_field = life.populate(field)

  local want_next_field =
    Field:new(Size:new(3, 3))
  want_next_field:set(Point:new(0, 1))
  want_next_field:set(Point:new(2, 1))
  want_next_field:set(Point:new(1, 2))
  want_next_field:set(Point:new(2, 2))

  luaunit.assertEquals(
    next_field,
    want_next_field
  )
end 
