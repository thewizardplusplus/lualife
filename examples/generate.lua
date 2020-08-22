local Size = require("lualife.models.size")
local Field = require("lualife.models.field")
local random = require("lualife.random")
local life = require("lualife.life")

local function print_field(field)
  assert(field.isInstanceOf and field:isInstanceOf(Field))

  field:map(function(point, contains)
    io.write(contains and "O" or ".")

    if point.x == field.size.width - 1 then
      io.write("\n")
    end
  end)
end

local function sleep(seconds)
  assert(type(seconds) == "number")

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
