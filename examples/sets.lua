local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local PlacedField = require("lualife.models.placedfield")
local sets = require("lualife.sets")

local function print_field(field)
  assert(field.isInstanceOf and field:isInstanceOf(PlacedField))

  field:map(function(point, contains)
    io.write(contains and "O" or ".")

    if point.x - field.offset.x == field.size.width - 1 then
      io.write("\n")
    end
  end)

  io.write("\n")
end

local glider = PlacedField:new(Size:new(3, 3), Point:new(2, 2))
glider:set(Point:new(3, 2))
glider:set(Point:new(4, 3))
glider:set(Point:new(2, 4))
glider:set(Point:new(3, 4))
glider:set(Point:new(4, 4))

local blinker = PlacedField:new(Size:new(3, 3), Point:new(1, 2))
blinker:set(Point:new(2, 2))
blinker:set(Point:new(2, 3))
blinker:set(Point:new(2, 4))

local unioned_field = sets.union(glider, blinker)
print_field(unioned_field)

local complemented_field = sets.complement(glider, blinker)
print_field(complemented_field)

local intersected_field = sets.intersection(glider, blinker)
print_field(intersected_field)
