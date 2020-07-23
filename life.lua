local scriptFile = arg[0]
local scriptPath = scriptFile:match '.*/'
local Point = require(scriptPath .. 'point')

local function neighbors(field, point)
  local neighbors = 0
  for dy = -1, 1 do
    for dx = -1, 1 do
      local translatedPoint =
        	point:translate(Point:new(dx, dy))
      local central = dx == 0 and dy == 0
      local contains =
        field:contains(translatedPoint)
      if not central and contains then
        neighbors = neighbors + 1
      end
    end
  end
  
  return neighbors
end

local function populate(field)
end

return {
  neighbors = neighbors,
  populate = populate,
}
