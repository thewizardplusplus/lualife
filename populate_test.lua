local scriptFile = arg[0]
local scriptPath = scriptFile:match '.*/'
local luaunit = require(
	 scriptPath .. 'vendor/luaunit/luaunit'
)
local Size = require(scriptPath .. 'size')
local Point = require(scriptPath .. 'point')
local Field = require(scriptPath .. 'field')
local life =
  require(scriptPath .. 'populate')

TestNeighbors = {}

function TestNeighbors:test()
  local field = Field:new(Size:new(3, 3))
  field:set(Point:new(0, 0))
  field:set(Point:new(1, 0))
  field:set(Point:new(0, 1))
  field:set(Point:new(1, 1))

  local neighbors =
    life.neighbors(field, Point:new(1, 1))

  luaunit.assertEquals(neighbors, 3)
end

os.exit(luaunit.run()) 
