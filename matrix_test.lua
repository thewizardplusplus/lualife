local luaunit = require("luaunit")
local Size = require("lualife.models.size")
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

function TestMatrix.test_rotate()
  local field = Field:new(Size:new(3, 3))

  local rotated_field = matrix.rotate(field)

  local want_rotated_field = Field:new(Size:new(3, 3))

  luaunit.assert_true(rotated_field:isInstanceOf(Field))
  luaunit.assert_equals(rotated_field, want_rotated_field)
end
