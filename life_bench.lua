local benchutils = require("lualife.benchutils")
local benchlocalutils = require("lualife.benchlocalutils")
local life = require("lualife.life")

-- luacheck: globals TestLifeBench
TestLifeBench = {}

function TestLifeBench.setupClass()
  benchutils.print_name()
end

function TestLifeBench.test_populate_field()
  for _, size in ipairs(benchlocalutils.SIZES) do
    local field = benchlocalutils.new_field(size)

    benchutils.run(string.format(
      "life.populate(Field) (%dx%d, %g%% alive)",
      field.size.width,
      field.size.height,
      100 / benchlocalutils.DEFAULT_DENOMINATOR
    ), function()
      return life.populate(field)
    end)
  end
end

function TestLifeBench.test_populate_placed_field()
  for _, size in ipairs(benchlocalutils.SIZES) do
    local field = benchlocalutils.new_placed_field(size)

    benchutils.run(string.format(
      "life.populate(PlacedField) (%dx%d, %g%% alive)",
      field.size.width,
      field.size.height,
      100 / benchlocalutils.DEFAULT_DENOMINATOR
    ), function()
      return life.populate(field)
    end)
  end
end
