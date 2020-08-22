local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local Field = require("lualife.models.field")
local matrix = require("lualife.matrix")

local function print_field(field)
  assert(field.isInstanceOf and field:isInstanceOf(Field))

  field:map(function(point, contains)
    io.write(contains and "O" or ".")

    if point.x == field.size.width - 1 then
      io.write("\n")
    end
  end)
end

local field = Field:new(Size:new(3, 3))
field:set(Point:new(1, 0))
field:set(Point:new(2, 1))
field:set(Point:new(0, 2))
field:set(Point:new(1, 2))
field:set(Point:new(2, 2))

local rotated_field = matrix.rotate(field)
print_field(rotated_field)
