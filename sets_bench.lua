local benchutils = require("lualife.benchutils")
local benchlocalutils = require("lualife.benchlocalutils")
local sets = require("lualife.sets")

local _ADDITIONAL_DENOMINATOR = 3
local _ADDITIONAL_PHASE = 1

-- luacheck: globals TestSetsBench
TestSetsBench = {}

function TestSetsBench.setupClass()
  benchutils.print_name()
end

function TestSetsBench.test_union()
  for _, size in ipairs(benchlocalutils.SIZES) do
    local base = benchlocalutils.new_field(size)
    local additional = benchlocalutils.new_placed_field(
      size,
      _ADDITIONAL_DENOMINATOR,
      _ADDITIONAL_PHASE,
      math.floor(size / 5) -- offset
    )

    benchutils.run(string.format(
      "sets.union() (%dx%d, base: %g%% alive, additional: %g%% alive)",
      base.size.width,
      base.size.height,
      100 / benchlocalutils.DEFAULT_DENOMINATOR,
      100 / _ADDITIONAL_DENOMINATOR
    ), function()
      return sets.union(base, additional)
    end)
  end
end

function TestSetsBench.test_complement()
  for _, size in ipairs(benchlocalutils.SIZES) do
    local base = benchlocalutils.new_field(size)
    local additional = benchlocalutils.new_placed_field(
      size,
      _ADDITIONAL_DENOMINATOR,
      _ADDITIONAL_PHASE,
      math.floor(size / 5) -- offset
    )

    benchutils.run(string.format(
      "sets.complement() (%dx%d, base: %g%% alive, additional: %g%% alive)",
      base.size.width,
      base.size.height,
      100 / benchlocalutils.DEFAULT_DENOMINATOR,
      100 / _ADDITIONAL_DENOMINATOR
    ), function()
      return sets.complement(base, additional)
    end)
  end
end

function TestSetsBench.test_intersection()
  for _, size in ipairs(benchlocalutils.SIZES) do
    local base = benchlocalutils.new_field(size)
    local additional = benchlocalutils.new_placed_field(
      size,
      _ADDITIONAL_DENOMINATOR,
      _ADDITIONAL_PHASE,
      math.floor(size / 5) -- offset
    )

    benchutils.run(string.format(
      "sets.intersection() (%dx%d, base: %g%% alive, additional: %g%% alive)",
      base.size.width,
      base.size.height,
      100 / benchlocalutils.DEFAULT_DENOMINATOR,
      100 / _ADDITIONAL_DENOMINATOR
    ), function()
      return sets.intersection(base, additional)
    end)
  end
end
