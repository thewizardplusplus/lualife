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

  luaunit.assert_true(field.isInstanceOf and field:isInstanceOf(Field))

  luaunit.assert_true(field.size:isInstanceOf(Size))
  luaunit.assert_is(field.size, sample.size)

  luaunit.assert_is_table(field._cells)
  luaunit.assert_equals(field._cells, {
    ["{x = 1,y = 1}"] = true,
  })
end

function TestRandom.test_generate_large()
  math.randomseed(1)

  local sample = Field:new(Size:new(3, 3))
  local field = random.generate(sample, 0.8)

  luaunit.assert_true(field.isInstanceOf and field:isInstanceOf(Field))

  luaunit.assert_true(field.size:isInstanceOf(Size))
  luaunit.assert_is(field.size, sample.size)

  luaunit.assert_is_table(field._cells)
  luaunit.assert_equals(field._cells, {
    ["{x = 0,y = 0}"] = true,
    ["{x = 1,y = 0}"] = true,
    ["{x = 2,y = 0}"] = true,
    ["{x = 1,y = 1}"] = true,
    ["{x = 2,y = 1}"] = true,
    ["{x = 0,y = 2}"] = true,
    ["{x = 1,y = 2}"] = true,
    ["{x = 2,y = 2}"] = true,
  })
end

function TestRandom.test_generate_placed()
  math.randomseed(1)

  local sample = PlacedField:new(Size:new(3, 3), Point:new(23, 42))
  local field = random.generate(sample, 0.8)

  luaunit.assert_true(field.isInstanceOf and field:isInstanceOf(PlacedField))

  luaunit.assert_true(field.size:isInstanceOf(Size))
  luaunit.assert_is(field.size, sample.size)

  luaunit.assert_true(field.offset:isInstanceOf(Point))
  luaunit.assert_is(field.offset, sample.offset)

  luaunit.assert_is_table(field._cells)
  luaunit.assert_equals(field._cells, {
    ["{x = 0,y = 0}"] = true,
    ["{x = 1,y = 0}"] = true,
    ["{x = 2,y = 0}"] = true,
    ["{x = 1,y = 1}"] = true,
    ["{x = 2,y = 1}"] = true,
    ["{x = 0,y = 2}"] = true,
    ["{x = 1,y = 2}"] = true,
    ["{x = 2,y = 2}"] = true,
  })
end

function TestRandom.test_generate_with_limits_small()
  math.randomseed(1)

  local sample = Field:new(Size:new(3, 3))
  local field = random.generate_with_limits(sample, 0.5, 1, 1)

  luaunit.assert_true(field.isInstanceOf and field:isInstanceOf(Field))

  luaunit.assert_true(field.size:isInstanceOf(Size))
  luaunit.assert_is(field.size, sample.size)

  luaunit.assert_is_table(field._cells)
  luaunit.assert_equals(field._cells, {
    ["{x = 1,y = 1}"] = true,
  })
end

function TestRandom.test_generate_with_limits_large()
  math.randomseed(1)

  local sample = Field:new(Size:new(3, 3))
  local field = random.generate_with_limits(sample, 0.5, 8, 8)

  luaunit.assert_true(field.isInstanceOf and field:isInstanceOf(Field))

  luaunit.assert_true(field.size:isInstanceOf(Size))
  luaunit.assert_is(field.size, sample.size)

  luaunit.assert_is_table(field._cells)
  luaunit.assert_equals(field._cells, {
    ["{x = 0,y = 0}"] = true,
    ["{x = 2,y = 0}"] = true,
    ["{x = 0,y = 1}"] = true,
    ["{x = 1,y = 1}"] = true,
    ["{x = 2,y = 1}"] = true,
    ["{x = 0,y = 2}"] = true,
    ["{x = 1,y = 2}"] = true,
    ["{x = 2,y = 2}"] = true,
  })
end

function TestRandom.test_generate_with_limits_placed()
  math.randomseed(1)

  local sample = PlacedField:new(Size:new(3, 3), Point:new(23, 42))
  local field = random.generate_with_limits(sample, 0.5, 8, 8)

  luaunit.assert_true(field.isInstanceOf and field:isInstanceOf(PlacedField))

  luaunit.assert_true(field.size:isInstanceOf(Size))
  luaunit.assert_is(field.size, sample.size)

  luaunit.assert_true(field.offset:isInstanceOf(Point))
  luaunit.assert_is(field.offset, sample.offset)

  luaunit.assert_is_table(field._cells)
  luaunit.assert_equals(field._cells, {
    ["{x = 0,y = 0}"] = true,
    ["{x = 2,y = 0}"] = true,
    ["{x = 0,y = 1}"] = true,
    ["{x = 1,y = 1}"] = true,
    ["{x = 2,y = 1}"] = true,
    ["{x = 0,y = 2}"] = true,
    ["{x = 1,y = 2}"] = true,
    ["{x = 2,y = 2}"] = true,
  })
end
