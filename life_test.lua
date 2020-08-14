local luaunit = require("luaunit")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local Field = require("lualife.models.field")
local life = require("lualife.life")

-- luacheck: globals TestLife
TestLife = {}

function TestLife.test_neighbors()
  local field = Field:new(Size:new(3, 3))
  field:set(Point:new(0, 0))
  field:set(Point:new(1, 0))
  field:set(Point:new(0, 1))
  field:set(Point:new(1, 1))

  local neighbors = life.neighbors(field, Point:new(1, 1))

  luaunit.assert_is_number(neighbors)
  luaunit.assert_equals(neighbors, 3)
end

function TestLife.test_populate_blinker()
  local field = Field:new(Size:new(3, 3))
  field:set(Point:new(0, 1))
  field:set(Point:new(1, 1))
  field:set(Point:new(2, 1))

  local next_field = life.populate(field)

  local want_next_field = Field:new(Size:new(3, 3))
  want_next_field:set(Point:new(1, 0))
  want_next_field:set(Point:new(1, 1))
  want_next_field:set(Point:new(1, 2))

  luaunit.assert_true(next_field:isInstanceOf(Field))
  luaunit.assert_equals(next_field, want_next_field)
end

function TestLife.test_populate_glider_full()
  local field = Field:new(Size:new(4, 4))
  field:set(Point:new(1, 0))
  field:set(Point:new(2, 1))
  field:set(Point:new(0, 2))
  field:set(Point:new(1, 2))
  field:set(Point:new(2, 2))

  local next_field = life.populate(field)

  local want_next_field = Field:new(Size:new(4, 4))
  want_next_field:set(Point:new(0, 1))
  want_next_field:set(Point:new(2, 1))
  want_next_field:set(Point:new(1, 2))
  want_next_field:set(Point:new(2, 2))
  want_next_field:set(Point:new(1, 3))

  luaunit.assert_true(next_field:isInstanceOf(Field))
  luaunit.assert_equals(next_field, want_next_field)
end

function TestLife.test_populate_glider_partial()
  local field = Field:new(Size:new(3, 3))
  field:set(Point:new(1, 0))
  field:set(Point:new(2, 1))
  field:set(Point:new(0, 2))
  field:set(Point:new(1, 2))
  field:set(Point:new(2, 2))

  local next_field = life.populate(field)

  local want_next_field = Field:new(Size:new(3, 3))
  want_next_field:set(Point:new(0, 1))
  want_next_field:set(Point:new(2, 1))
  want_next_field:set(Point:new(1, 2))
  want_next_field:set(Point:new(2, 2))

  luaunit.assert_true(next_field:isInstanceOf(Field))
  luaunit.assert_equals(next_field, want_next_field)
end
