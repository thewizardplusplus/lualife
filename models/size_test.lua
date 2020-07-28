local luaunit = require("luaunit")
local Size = require("lualife.models.size")

-- luacheck: globals TestSize
TestSize = {}

function TestSize.test_new()
  local size = Size:new(23, 42)

  luaunit.assert_true(size:isInstanceOf(Size))

  luaunit.assert_is_number(size.width)
  luaunit.assert_equals(size.width, 23)

  luaunit.assert_is_number(size.height)
  luaunit.assert_equals(size.height, 42)
end
