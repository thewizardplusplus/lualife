local scriptFile = arg[0]
local scriptPath = scriptFile:match '.*/'
local luaunit = require(
	 scriptPath .. 'vendor/luaunit/luaunit'
)
local Size = require(scriptPath .. 'size')
local Point = require(scriptPath .. 'point')
local Field = require(scriptPath .. 'field')
local life = require(scriptPath .. 'life')

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

TestPopulate = {}

function TestPopulate:testBlinker()
  local field = Field:new(Size:new(3, 3))
  field:set(Point:new(0, 1))
  field:set(Point:new(1, 1))
  field:set(Point:new(2, 1))

  local nextField = life.populate(field)

  local wantNextField =
    Field:new(Size:new(3, 3))
  wantNextField:set(Point:new(1, 0))
  wantNextField:set(Point:new(1, 1))
  wantNextField:set(Point:new(1, 2))

  luaunit.assertEquals(
    nextField,
    wantNextField
  )
end

function TestPopulate:testGliderFull()
  local field = Field:new(Size:new(4, 4))
  field:set(Point:new(1, 0))
  field:set(Point:new(2, 1))
  field:set(Point:new(0, 2))
  field:set(Point:new(1, 2))
  field:set(Point:new(2, 2))

  local nextField = life.populate(field)

  local wantNextField =
    Field:new(Size:new(4, 4))
  wantNextField:set(Point:new(0, 1))
  wantNextField:set(Point:new(2, 1))
  wantNextField:set(Point:new(1, 2))
  wantNextField:set(Point:new(2, 2))
  wantNextField:set(Point:new(1, 3))

  luaunit.assertEquals(
    nextField,
    wantNextField
  )
end

function TestPopulate:testGliderPartial()
  local field = Field:new(Size:new(3, 3))
  field:set(Point:new(1, 0))
  field:set(Point:new(2, 1))
  field:set(Point:new(0, 2))
  field:set(Point:new(1, 2))
  field:set(Point:new(2, 2))

  local nextField = life.populate(field)

  local wantNextField =
    Field:new(Size:new(3, 3))
  wantNextField:set(Point:new(0, 1))
  wantNextField:set(Point:new(2, 1))
  wantNextField:set(Point:new(1, 2))
  wantNextField:set(Point:new(2, 2))

  luaunit.assertEquals(
    nextField,
    wantNextField
  )
end

os.exit(luaunit.run()) 
