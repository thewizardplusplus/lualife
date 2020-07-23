local scriptFile = arg[0]
local scriptPath = scriptFile:match '.*/'
local luaunit = require(
	 scriptPath .. 'vendor/luaunit/luaunit'
)
local Point = require(scriptPath .. 'point')

TestPoint = {}

function TestPoint:testNew()
  local point = Point:new(23, 42)

  luaunit.assertEquals(point.x, 23)
  luaunit.assertEquals(point.y, 42)
end

function TestPoint:testToString()
  local point = Point:new(23, 42)
  local text = tostring(point)

  luaunit.assertEquals('(23, 42)', text)
end

function TestPoint:testTranslate()
  local point = Point:new(5, 12)
  local translatedPoint =
    point:translate(Point:new(23, 42))

  luaunit.assertEquals(
    translatedPoint,
    Point:new(28, 54)
  )
end

os.exit(luaunit.run()) 
