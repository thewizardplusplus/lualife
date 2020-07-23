local scriptFile = arg[0]
local scriptPath = scriptFile:match '.*/'
local luaunit = require(
	 scriptPath .. 'vendor/luaunit/luaunit'
)
local Size = require(scriptPath .. 'size')
local Point = require(scriptPath .. 'point')
local Field = require(scriptPath .. 'field')

TestField = {}

function TestField:testNew()
  local size = Size:new(23, 42)
  local field = Field:new(size)

  luaunit.assertEquals(field.size, size)
  luaunit.assertEquals(field.cells, {})
end

function TestField:testContains()
  local field = Field:new()
  field:set(Point:new(2, 3))
  field:set(Point:new(4, 2))

  local point =
    field:contains(Point:new(2, 3))
  luaunit.assertEquals(point, true)

  local missedPoint =
    field:contains(Point:new(1, 2))
  luaunit.assertEquals(missedPoint, false)
end

function TestField:testSet()
  local field = Field:new()
  field:set(Point:new(2, 3))
  field:set(Point:new(4, 2))

  luaunit.assertEquals(field.cells, {
  	 ['(2, 3)'] = true,
  	 ['(4, 2)'] = true,
  })
end

os.exit(luaunit.run()) 
