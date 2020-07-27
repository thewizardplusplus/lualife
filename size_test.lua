local luaunit = require("luaunit")
local Size = require("lualife.size")

TestSize = {}

function TestSize.test_new()
  local size = Size:new(23, 42)
  
  luaunit.assertTrue(size:isInstanceOf(Size))

  luaunit.assertIsNumber(size.width)
  luaunit.assertEquals(size.width, 23)

  luaunit.assertIsNumber(size.height)
  luaunit.assertEquals(size.height, 42)
end 
