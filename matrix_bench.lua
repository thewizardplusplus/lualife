local benchutils = require("lualife.benchutils")
local benchlocalutils = require("lualife.benchlocalutils")
local matrix = require("lualife.matrix")

-- luacheck: globals TestMatrixBench
TestMatrixBench = {}

function TestMatrixBench.setupClass()
  benchutils.print_name()
end

function TestMatrixBench.test_rotate_field()
  for _, size in ipairs(benchlocalutils.SIZES) do
    local field = benchlocalutils.new_field(size)

    benchutils.run(string.format(
      "matrix.rotate(Field) (%dx%d, %g%% alive)",
      field.size.width,
      field.size.height,
      100 / benchlocalutils.DEFAULT_DENOMINATOR
    ), function()
      return matrix.rotate(field)
    end)
  end
end

function TestMatrixBench.test_rotate_placed_field()
  for _, size in ipairs(benchlocalutils.SIZES) do
    local field = benchlocalutils.new_placed_field(size)

    benchutils.run(string.format(
      "matrix.rotate(PlacedField) (%dx%d, %g%% alive)",
      field.size.width,
      field.size.height,
      100 / benchlocalutils.DEFAULT_DENOMINATOR
    ), function()
      return matrix.rotate(field)
    end)
  end
end
