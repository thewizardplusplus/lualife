local luaunit = require("luaunit")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local Field = require("lualife.models.field")
local PlacedField = require("lualife.models.placedfield")
local random = require("lualife.random")

-- luacheck: globals TestRandom
TestRandom = {}

function TestRandom.test_generate_small()
  math.randomseed(1)

  local sample = Field:new(Size:new(3, 3))
  local field = random.generate(sample, 0.2)

  luaunit.assert_true(field:isInstanceOf(Field))

  luaunit.assert_true(field.size:isInstanceOf(Size))
  luaunit.assert_is(field.size, sample.size)

  luaunit.assert_is_table(field.cells)
  luaunit.assert_equals(field.cells, {
    ["(1, 1)"] = true,
  })
end

function TestRandom.test_generate_large()
  math.randomseed(1)

  local sample = Field:new(Size:new(3, 3))
  local field = random.generate(sample, 0.8)

  luaunit.assert_true(field:isInstanceOf(Field))

  luaunit.assert_true(field.size:isInstanceOf(Size))
  luaunit.assert_is(field.size, sample.size)

  luaunit.assert_is_table(field.cells)
  luaunit.assert_equals(field.cells, {
    ["(0, 0)"] = true,
    ["(1, 0)"] = true,
    ["(2, 0)"] = true,
    ["(1, 1)"] = true,
    ["(2, 1)"] = true,
    ["(0, 2)"] = true,
    ["(1, 2)"] = true,
    ["(2, 2)"] = true,
  })
end

function TestRandom.test_generate_placed()
  math.randomseed(1)

  local sample = PlacedField:new(Size:new(3, 3), Point:new(23, 42))
  local field = random.generate(sample, 0.8)

  luaunit.assert_true(field:isInstanceOf(PlacedField))

  luaunit.assert_true(field.size:isInstanceOf(Size))
  luaunit.assert_is(field.size, sample.size)

  luaunit.assert_true(field.offset:isInstanceOf(Point))
  luaunit.assert_is(field.offset, sample.offset)

  luaunit.assert_is_table(field.cells)
  luaunit.assert_equals(field.cells, {
    ["(0, 0)"] = true,
    ["(1, 0)"] = true,
    ["(2, 0)"] = true,
    ["(1, 1)"] = true,
    ["(2, 1)"] = true,
    ["(0, 2)"] = true,
    ["(1, 2)"] = true,
    ["(2, 2)"] = true,
  })
end

function TestRandom.test_generate_with_limits_small()
  math.randomseed(1)

  local sample = Field:new(Size:new(3, 3))
  local field = random.generate_with_limits(sample, 0.5, 1, 1)

  luaunit.assert_true(field:isInstanceOf(Field))

  luaunit.assert_true(field.size:isInstanceOf(Size))
  luaunit.assert_is(field.size, sample.size)

  luaunit.assert_is_table(field.cells)
  luaunit.assert_equals(field.cells, {
    ["(1, 1)"] = true,
  })
end

function TestRandom.test_generate_with_limits_large()
  math.randomseed(1)

  local sample = Field:new(Size:new(3, 3))
  local field = random.generate_with_limits(sample, 0.5, 8, 8)

  luaunit.assert_true(field:isInstanceOf(Field))

  luaunit.assert_true(field.size:isInstanceOf(Size))
  luaunit.assert_is(field.size, sample.size)

  luaunit.assert_is_table(field.cells)
  luaunit.assert_equals(field.cells, {
    ["(0, 0)"] = true,
    ["(2, 0)"] = true,
    ["(0, 1)"] = true,
    ["(1, 1)"] = true,
    ["(2, 1)"] = true,
    ["(0, 2)"] = true,
    ["(1, 2)"] = true,
    ["(2, 2)"] = true,
  })
end

function TestRandom.test_generate_with_limits_placed()
  math.randomseed(1)

  local sample = PlacedField:new(Size:new(3, 3), Point:new(23, 42))
  local field = random.generate_with_limits(sample, 0.5, 8, 8)

  luaunit.assert_true(field:isInstanceOf(PlacedField))

  luaunit.assert_true(field.size:isInstanceOf(Size))
  luaunit.assert_is(field.size, sample.size)

  luaunit.assert_true(field.offset:isInstanceOf(Point))
  luaunit.assert_is(field.offset, sample.offset)

  luaunit.assert_is_table(field.cells)
  luaunit.assert_equals(field.cells, {
    ["(0, 0)"] = true,
    ["(2, 0)"] = true,
    ["(0, 1)"] = true,
    ["(1, 1)"] = true,
    ["(2, 1)"] = true,
    ["(0, 2)"] = true,
    ["(1, 2)"] = true,
    ["(2, 2)"] = true,
  })
end
