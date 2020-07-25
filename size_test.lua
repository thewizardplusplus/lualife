local script_file = arg[0]
local script_path = script_file:match(".*/")

local luaunit = require(
	 script_path .. "vendor/luaunit/luaunit"
)

local Size = require(script_path .. "size")

TestSize = {}

function TestSize.test_new()
  local size = Size:new(23, 42)

  luaunit.assertEquals(size.width, 23)
  luaunit.assertEquals(size.height, 42)
end

os.exit(luaunit.run()) 
