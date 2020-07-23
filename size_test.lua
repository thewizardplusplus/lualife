local scriptFile = arg[0]
local scriptPath = scriptFile:match '.*/'
local luaunit = require(
	 scriptPath .. 'vendor/luaunit/luaunit'
)
local Size = require(scriptPath .. 'size')

TestSize = {}

function TestSize:testNew()
  local size = Size:new(23, 42)

  luaunit.assertEquals(size.width, 23)
  luaunit.assertEquals(size.height, 42)
end

os.exit(luaunit.run()) 
