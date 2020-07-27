local luaunit = require("luaunit")
local Size = require("lualife.size")

TestSize = {}

function TestSize.test_new()
  local size = Size:new(23, 42)

  luaunit.assertEquals(size.width, 23)
  luaunit.assertEquals(size.height, 42)
end 
