local assertions = require("luatypechecks.assertions")
local json = require("luaserialization.json")
local Vector2D = require("luamath.vector2d")
local Size = require("luamath.models.size")
local BoundingBox = require("luamath.models.boundingbox")
local benchutils = require("lualife.benchutils")
local benchlocalutils = require("lualife.benchlocalutils")
local PlacedField = require("lualife.models.placedfield")

-- luacheck: globals TestPlacedFieldBench
TestPlacedFieldBench = {}

function TestPlacedFieldBench.setupClass()
  benchutils.print_name()
end

function TestPlacedFieldBench.test_from_json()
  for _, size in ipairs(benchlocalutils.SIZES) do
    local field = benchlocalutils.new_placed_field(size)
    local text = assert(json.to_json(field))

    benchutils.run(string.format(
      "json.from_json(PlacedField) (%dx%d, %g%% alive)",
      field.size.width,
      field.size.height,
      100 / benchlocalutils.DEFAULT_DENOMINATOR
    ), function()
      return json.from_json(text, PlacedField.schema(), {
        Vector2D = Vector2D.from_options,
        Size = Size.from_options,
        BoundingBox = BoundingBox.from_options,
        PlacedField = PlacedField.from_options,
      })
    end)
  end
end

function TestPlacedFieldBench.test_place()
  for _, size in ipairs(benchlocalutils.SIZES) do
    local field = benchlocalutils.new_field(size)

    benchutils.run(string.format(
      "PlacedField.place() (%dx%d, %g%% alive)",
      field.size.width,
      field.size.height,
      100 / benchlocalutils.DEFAULT_DENOMINATOR
    ), function()
      return PlacedField.place(field, field.size)
    end)
  end
end

function TestPlacedFieldBench.test_tostring()
  for _, size in ipairs(benchlocalutils.SIZES) do
    local field = benchlocalutils.new_placed_field(size)

    benchutils.run(string.format(
      "tostring(PlacedField) (%dx%d, %g%% alive)",
      field.size.width,
      field.size.height,
      100 / benchlocalutils.DEFAULT_DENOMINATOR
    ), function()
      return tostring(field)
    end)
  end
end

function TestPlacedFieldBench.test_count()
  for _, size in ipairs(benchlocalutils.SIZES) do
    local field = benchlocalutils.new_placed_field(size)

    benchutils.run(string.format(
      "PlacedField:count() (%dx%d, %g%% alive)",
      field.size.width,
      field.size.height,
      100 / benchlocalutils.DEFAULT_DENOMINATOR
    ), function()
      return field:count()
    end)
  end
end

function TestPlacedFieldBench.test_offset()
  for _, size in ipairs(benchlocalutils.SIZES) do
    local field =
      PlacedField:new(Size:new(size, size), Vector2D:new(size, size))

    benchutils.run(string.format(
      "PlacedField:offset() (%dx%d)",
      field.size.width,
      field.size.height
    ), function()
      return field:offset()
    end)
  end
end

function TestPlacedFieldBench.test_contains()
  for _, size in ipairs(benchlocalutils.SIZES) do
    local field = benchlocalutils.new_placed_field(size)
    local points = benchlocalutils.collect_points(field)

    benchutils.run(string.format(
      "PlacedField:contains() x%d (%dx%d)",
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

function TestPlacedFieldBench.test_fits()
  for _, size in ipairs(benchlocalutils.SIZES) do
    local field = PlacedField:new(Size:new(size, size), Vector2D:new(1, 1))
    local container = PlacedField:new(field.size + Vector2D:new(2, 2))

    benchutils.run(string.format(
      "PlacedField:fits() (%dx%d in %dx%d)",
      field.size.width,
      field.size.height,
      container.size.width,
      container.size.height
    ), function()
      return field:fits(container)
    end)
  end
end

function TestPlacedFieldBench.test_set()
  for _, size in ipairs(benchlocalutils.SIZES) do
    local sample =
      PlacedField:new(Size:new(size, size), Vector2D:new(size, size))
    local points = benchlocalutils.collect_points(sample, "pattern")

    benchutils.run(string.format(
      "PlacedField:set() x%d (%dx%d)",
      #points,
      sample.size.width,
      sample.size.height
    ), function()
      local field = PlacedField:new(sample.size, sample:offset())
      for _, point in ipairs(points) do
        field:set(point)
      end

      return field
    end)
  end
end

function TestPlacedFieldBench.test_map_copy()
  for _, size in ipairs(benchlocalutils.SIZES) do
    local field = benchlocalutils.new_placed_field(size)

    benchutils.run(string.format(
      "PlacedField:map() copy (%dx%d, %g%% alive)",
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
