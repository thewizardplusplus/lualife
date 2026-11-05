local Size = require("luamath.models.size")
local Range = require("luamath.models.range")
local benchutils = require("lualife.benchutils")
local benchlocalutils = require("lualife.benchlocalutils")
local Field = require("lualife.models.field")
local random = require("lualife.random")

local _TARGET_FILLING = 0.2
local _MIN_ALIVE_RATIO, _MAX_ALIVE_RATIO = 0.18, 0.22

-- luacheck: globals TestRandomBench
TestRandomBench = {}

function TestRandomBench.setupClass()
  benchutils.print_name()
end

function TestRandomBench.test_generate()
  for _, size in ipairs(benchlocalutils.SIZES) do
    math.randomseed(1)

    local sample = Field:new(Size:new(size, size))

    benchutils.run(string.format(
      "random.generate() (%dx%d, filling: %g%%)",
      sample.size.width,
      sample.size.height,
      100 * _TARGET_FILLING
    ), function()
      return random.generate(sample, _TARGET_FILLING)
    end)
  end
end

function TestRandomBench.test_generate_with_limits()
  for _, size in ipairs(benchlocalutils.SIZES) do
    local sample = Field:new(Size:new(size, size))
    local sample_area = sample.size.width * sample.size.height
    local count_range = Range:new(
      math.floor(sample_area * _MIN_ALIVE_RATIO),
      math.ceil(sample_area * _MAX_ALIVE_RATIO)
    )

    math.randomseed(1)

    benchutils.run(string.format(
      "random.generate_with_limits() (%dx%d, filling: %g%%, %g..%g%% alive)",
      sample.size.width,
      sample.size.height,
      100 * _TARGET_FILLING,
      100 * _MIN_ALIVE_RATIO,
      100 * _MAX_ALIVE_RATIO
    ), function()
      return random.generate_with_limits(sample, _TARGET_FILLING, count_range)
    end)
  end
end
