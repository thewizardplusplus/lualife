local luaunit = require("luaunit")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local Field = require("lualife.models.field")
local sets = require("lualife.sets")

-- luacheck: globals TestSets
TestSets = {}

function TestSets.test_union_intersection()
  local field = Field:new(Size:new(3, 3))
  field:set(Point:new(0, 0))
  field:set(Point:new(1, 0))
  field:set(Point:new(0, 1))
  field:set(Point:new(1, 1))

  local unioned_field = sets.union(field, field, Point:new(1, 1))

  local want_unioned_field = Field:new(Size:new(3, 3))
  want_unioned_field:set(Point:new(0, 0))
  want_unioned_field:set(Point:new(1, 0))
  want_unioned_field:set(Point:new(0, 1))
  want_unioned_field:set(Point:new(1, 1))
  want_unioned_field:set(Point:new(2, 1))
  want_unioned_field:set(Point:new(1, 2))
  want_unioned_field:set(Point:new(2, 2))

  luaunit.assert_true(unioned_field:isInstanceOf(Field))
  luaunit.assert_equals(unioned_field, want_unioned_field)
end

function TestSets.test_union_out_of_size()
  local field = Field:new(Size:new(3, 3))
  field:set(Point:new(0, 0))
  field:set(Point:new(1, 0))
  field:set(Point:new(0, 1))
  field:set(Point:new(1, 1))

  local unioned_field = sets.union(field, field, Point:new(2, 2))

  local want_unioned_field = Field:new(Size:new(3, 3))
  want_unioned_field:set(Point:new(0, 0))
  want_unioned_field:set(Point:new(1, 0))
  want_unioned_field:set(Point:new(0, 1))
  want_unioned_field:set(Point:new(1, 1))
  want_unioned_field:set(Point:new(2, 2))

  luaunit.assert_true(unioned_field:isInstanceOf(Field))
  luaunit.assert_equals(unioned_field, want_unioned_field)
end

function TestSets.test_complement()
  local field = Field:new(Size:new(3, 3))
  field:set(Point:new(0, 0))
  field:set(Point:new(1, 0))
  field:set(Point:new(0, 1))
  field:set(Point:new(1, 1))

  local complemented_field = sets.complement(field, field, Point:new(1, 1))

  local want_complemented_field = Field:new(Size:new(3, 3))
  want_complemented_field:set(Point:new(0, 0))
  want_complemented_field:set(Point:new(1, 0))
  want_complemented_field:set(Point:new(0, 1))

  luaunit.assert_true(complemented_field:isInstanceOf(Field))
  luaunit.assert_equals(complemented_field, want_complemented_field)
end
