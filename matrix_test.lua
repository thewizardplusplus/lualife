local luaunit = require("luaunit")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local Field = require("lualife.models.field")
local matrix = require("lualife.matrix")

-- luacheck: globals TestMatrix
TestMatrix = {}

function TestMatrix.test_rotate_nonsquare()
  local field = Field:new(Size:new(2, 3))

  luaunit.assert_error_msg_contains(
    "rotation of the non-square matrix",
    function()
      matrix.rotate(field)
    end
  )
end

function TestMatrix.test_rotate_odd()
  local field = Field:new(Size:new(3, 3))
  field:set(Point:new(0, 0))
  field:set(Point:new(1, 0))
  field:set(Point:new(2, 0))
  field:set(Point:new(0, 1))
  field:set(Point:new(1, 1))
  field:set(Point:new(0, 2))

  local rotated_field = matrix.rotate(field)

  local want_rotated_field = Field:new(Size:new(3, 3))
  want_rotated_field:set(Point:new(0, 0))
  want_rotated_field:set(Point:new(1, 0))
  want_rotated_field:set(Point:new(2, 0))
  want_rotated_field:set(Point:new(1, 1))
  want_rotated_field:set(Point:new(2, 1))
  want_rotated_field:set(Point:new(2, 2))

  luaunit.assert_true(rotated_field:isInstanceOf(Field))
  luaunit.assert_equals(rotated_field, want_rotated_field)
end

function TestMatrix.test_rotate_even()
  local field = Field:new(Size:new(4, 4))
  field:set(Point:new(0, 0))
  field:set(Point:new(1, 0))
  field:set(Point:new(2, 0))
  field:set(Point:new(3, 0))
  field:set(Point:new(0, 1))
  field:set(Point:new(1, 1))
  field:set(Point:new(2, 1))
  field:set(Point:new(0, 2))
  field:set(Point:new(1, 2))
  field:set(Point:new(0, 3))

  local rotated_field = matrix.rotate(field)

  local want_rotated_field = Field:new(Size:new(4, 4))
  want_rotated_field:set(Point:new(0, 0))
  want_rotated_field:set(Point:new(1, 0))
  want_rotated_field:set(Point:new(2, 0))
  want_rotated_field:set(Point:new(3, 0))
  want_rotated_field:set(Point:new(1, 1))
  want_rotated_field:set(Point:new(2, 1))
  want_rotated_field:set(Point:new(3, 1))
  want_rotated_field:set(Point:new(2, 2))
  want_rotated_field:set(Point:new(3, 2))
  want_rotated_field:set(Point:new(3, 3))

  luaunit.assert_true(rotated_field:isInstanceOf(Field))
  luaunit.assert_equals(rotated_field, want_rotated_field)
end
