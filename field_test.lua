local scriptFile = arg[0]
local scriptPath = scriptFile:match '.*/'
local luaunit = require(
	 scriptPath .. 'vendor/luaunit/luaunit'
)
local Point = require(scriptPath .. 'point')
local Field = require(scriptPath .. 'field')

TestField = {}

function TestField:testNew()
  local field = Field:new()

  luaunit.assertEquals(field.cells, {})
end

function TestField:testIsContains()
  local field = Field:new()
  field:set(Point:new(2, 3))
  field:set(Point:new(4, 2))

  local point =
  	 field:isContains(Point:new(2, 3))
  luaunit.assertEquals(point, true)

  local missedPoint =
  	 field:isContains(Point:new(1, 2))
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
