local assertions = require("luatypechecks.assertions")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local Field = require("lualife.models.field")
local random = require("lualife.random")
local life = require("lualife.life")

local function print_field(field)
  assertions.is_instance(field, Field)

  field:map(function(point, contains)
    assertions.is_instance(point, Point)
    assertions.is_boolean(contains)

    io.write(contains and "O" or ".")

    if point.x == field.size.width - 1 then
      io.write("\n")
    end
  end)
end

local function sleep(seconds)
  assertions.is_number(seconds)

  local start = os.clock()
  while os.clock() - start < seconds do end
end

math.randomseed(os.time())

local sample = Field:new(Size:new(10, 10))
local field = random.generate(sample, 0.5)
while true do
  field = life.populate(field)
  print_field(field)
  sleep(0.2)
end
