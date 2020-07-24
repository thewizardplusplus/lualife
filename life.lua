local scriptFile = arg[0]
local scriptPath = scriptFile:match '.*/'
local Point = require(scriptPath .. 'point')
local Field = require(scriptPath .. 'field')

local function neighbors(field, point)
  local neighbors = 0
  for dy = -1, 1 do
    for dx = -1, 1 do
      local translatedPoint =
        	point:translate(Point:new(dx, dy))
      local central = dx == 0 and dy == 0
      local alive =
        field:contains(translatedPoint)
      if not central and alive then
        neighbors = neighbors + 1
      end
    end
  end
  
  return neighbors
end

local function populate(field)
  local nextField = Field:new(field.size)
  for y = 0, field.size.height - 1 do
    for x = 0, field.size.width - 1 do
      local point = Point:new(x, y)
      local neighbors =
        neighbors(field, point)
      local alive = field:contains(point)
      if
        neighbors == 3
        or (neighbors == 2 and alive)
      then
        nextField:set(point)
      end
    end
  end

  return nextField
end

return {
  neighbors = neighbors,
  populate = populate,
}
