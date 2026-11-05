local assertions = require("luatypechecks.assertions")
local json = require("luaserialization.json")
local Vector2D = require("luamath.vector2d")
local Size = require("luamath.models.size")
local BoundingBox = require("luamath.models.boundingbox")
local benchutils = require("lualife.benchutils")
local benchlocalutils = require("lualife.benchlocalutils")
local Field = require("lualife.models.field")

-- luacheck: globals TestFieldBench
TestFieldBench = {}

function TestFieldBench.setupClass()
  benchutils.print_name()
end

function TestFieldBench.test_from_json()
  for _, size in ipairs(benchlocalutils.SIZES) do
    local field = benchlocalutils.new_field(size)
    local text = assert(json.to_json(field))

    benchutils.run(string.format(
      "json.from_json(Field) (%dx%d, %g%% alive)",
      field.size.width,
      field.size.height,
      100 / benchlocalutils.DEFAULT_DENOMINATOR
    ), function()
      return json.from_json(text, Field.schema(), {
        Vector2D = Vector2D.from_options,
        Size = Size.from_options,
        BoundingBox = BoundingBox.from_options,
        Field = Field.from_options,
      })
    end)
  end
end

function TestFieldBench.test_tostring()
  for _, size in ipairs(benchlocalutils.SIZES) do
    local field = benchlocalutils.new_field(size)

    benchutils.run(string.format(
      "tostring(Field) (%dx%d, %g%% alive)",
      field.size.width,
      field.size.height,
      100 / benchlocalutils.DEFAULT_DENOMINATOR
    ), function()
      return tostring(field)
    end)
  end
end

function TestFieldBench.test_count()
  for _, size in ipairs(benchlocalutils.SIZES) do
    local field = benchlocalutils.new_field(size)

    benchutils.run(string.format(
      "Field:count() (%dx%d, %g%% alive)",
      field.size.width,
      field.size.height,
      100 / benchlocalutils.DEFAULT_DENOMINATOR
    ), function()
      return field:count()
    end)
  end
end

function TestFieldBench.test_contains()
  for _, size in ipairs(benchlocalutils.SIZES) do
    local field = benchlocalutils.new_field(size)
    local points = benchlocalutils.collect_points(field)

    benchutils.run(string.format(
      "Field:contains() x%d (%dx%d)",
      #points,
      field.size.width,
      field.size.height
    ), function()
      local count = 0
      for _, point in ipairs(points) do
        if field:contains(point) then
          count = count + 1
        end
      end

      return count
    end)
  end
end

function TestFieldBench.test_fits()
  for _, size in ipairs(benchlocalutils.SIZES) do
    local field = Field:new(Size:new(size, size))
    local container = Field:new(field.size + Vector2D:new(2, 2))

    benchutils.run(string.format(
      "Field:fits() (%dx%d in %dx%d)",
      field.size.width,
      field.size.height,
      container.size.width,
      container.size.height
    ), function()
      return field:fits(container)
    end)
  end
end

function TestFieldBench.test_set()
  for _, size in ipairs(benchlocalutils.SIZES) do
    local sample = Field:new(Size:new(size, size))
    local points = benchlocalutils.collect_points(sample, "pattern")

    benchutils.run(string.format(
      "Field:set() x%d (%dx%d)",
      #points,
      sample.size.width,
      sample.size.height
    ), function()
      local field = Field:new(sample.size)
      for _, point in ipairs(points) do
        field:set(point)
      end

      return field
    end)
  end
end

function TestFieldBench.test_map_copy()
  for _, size in ipairs(benchlocalutils.SIZES) do
    local field = benchlocalutils.new_field(size)

    benchutils.run(string.format(
      "Field:map() copy (%dx%d, %g%% alive)",
      field.size.width,
      field.size.height,
      100 / benchlocalutils.DEFAULT_DENOMINATOR
    ), function()
      return field:map(function(_, contains)
        assertions.is_boolean(contains)

        return contains
      end)
    end)
  end
end
