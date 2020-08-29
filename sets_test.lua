local luaunit = require("luaunit")
local types = require("lualife.types")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local PlacedField = require("lualife.models.placedfield")
local sets = require("lualife.sets")

-- luacheck: globals TestSets
TestSets = {}

function TestSets.test_union_intersection()
  local field_one = PlacedField:new(Size:new(3, 3), Point:new(1, 1))
  field_one:set(Point:new(1, 1))
  field_one:set(Point:new(2, 1))
  field_one:set(Point:new(1, 2))
  field_one:set(Point:new(2, 2))

  local field_two = PlacedField:new(Size:new(3, 3), Point:new(2, 2))
  field_two:set(Point:new(2, 2))
  field_two:set(Point:new(3, 2))
  field_two:set(Point:new(2, 3))
  field_two:set(Point:new(3, 3))

  local unioned_field = sets.union(field_one, field_two)

  local want_unioned_field = PlacedField:new(Size:new(3, 3), Point:new(1, 1))
  want_unioned_field:set(Point:new(1, 1))
  want_unioned_field:set(Point:new(2, 1))
  want_unioned_field:set(Point:new(1, 2))
  want_unioned_field:set(Point:new(2, 2))
  want_unioned_field:set(Point:new(3, 2))
  want_unioned_field:set(Point:new(2, 3))
  want_unioned_field:set(Point:new(3, 3))

  luaunit.assert_true(types.is_instance(unioned_field, PlacedField))
  luaunit.assert_equals(unioned_field, want_unioned_field)
end

function TestSets.test_union_out_of_size()
  local field_one = PlacedField:new(Size:new(3, 3), Point:new(1, 1))
  field_one:set(Point:new(1, 1))
  field_one:set(Point:new(2, 1))
  field_one:set(Point:new(1, 2))
  field_one:set(Point:new(2, 2))

  local field_two = PlacedField:new(Size:new(3, 3), Point:new(3, 3))
  field_two:set(Point:new(3, 3))
  field_two:set(Point:new(4, 3))
  field_two:set(Point:new(3, 4))
  field_two:set(Point:new(4, 4))

  local unioned_field = sets.union(field_one, field_two)

  local want_unioned_field = PlacedField:new(Size:new(3, 3), Point:new(1, 1))
  want_unioned_field:set(Point:new(1, 1))
  want_unioned_field:set(Point:new(2, 1))
  want_unioned_field:set(Point:new(1, 2))
  want_unioned_field:set(Point:new(2, 2))
  want_unioned_field:set(Point:new(3, 3))

  luaunit.assert_true(types.is_instance(unioned_field, PlacedField))
  luaunit.assert_equals(unioned_field, want_unioned_field)
end

function TestSets.test_complement()
  local field_one = PlacedField:new(Size:new(3, 3), Point:new(1, 1))
  field_one:set(Point:new(1, 1))
  field_one:set(Point:new(2, 1))
  field_one:set(Point:new(1, 2))
  field_one:set(Point:new(2, 2))

  local field_two = PlacedField:new(Size:new(3, 3), Point:new(2, 2))
  field_two:set(Point:new(2, 2))
  field_two:set(Point:new(3, 2))
  field_two:set(Point:new(2, 3))
  field_two:set(Point:new(3, 3))

  local complemented_field = sets.complement(field_one, field_two)

  local want_complemented_field =
    PlacedField:new(Size:new(3, 3), Point:new(1, 1))
  want_complemented_field:set(Point:new(1, 1))
  want_complemented_field:set(Point:new(2, 1))
  want_complemented_field:set(Point:new(1, 2))

  luaunit.assert_true(types.is_instance(complemented_field, PlacedField))
  luaunit.assert_equals(complemented_field, want_complemented_field)
end

function TestSets.test_intersection()
  local field_one = PlacedField:new(Size:new(3, 3), Point:new(1, 1))
  field_one:set(Point:new(1, 1))
  field_one:set(Point:new(2, 1))
  field_one:set(Point:new(1, 2))
  field_one:set(Point:new(2, 2))

  local field_two = PlacedField:new(Size:new(3, 3), Point:new(2, 2))
  field_two:set(Point:new(2, 2))
  field_two:set(Point:new(3, 2))
  field_two:set(Point:new(2, 3))
  field_two:set(Point:new(3, 3))

  local intersected_field = sets.intersection(field_one, field_two)

  local want_intersected_field =
    PlacedField:new(Size:new(3, 3), Point:new(1, 1))
  want_intersected_field:set(Point:new(2, 2))

  luaunit.assert_true(types.is_instance(intersected_field, PlacedField))
  luaunit.assert_equals(intersected_field, want_intersected_field)
end
