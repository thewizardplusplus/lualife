local luaunit = require("luaunit")
local checks = require("luatypechecks.checks")
local Vector2D = require("luamath.vector2d")
local Size = require("luamath.models.size")
local Range = require("luamath.models.range")
local BoundingBox = require("luamath.models.boundingbox")
local Field = require("lualife.models.field")
local PlacedField = require("lualife.models.placedfield")
local random = require("lualife.random")

-- luacheck: globals TestRandom
TestRandom = {}

function TestRandom.test_generate_small()
  math.randomseed(1)

  local sample = Field:new(Size:new(3, 3))
  local field = random.generate(sample, 0.2)

  local wanted_cells
  if _VERSION == "Lua 5.5" or _VERSION == "Lua 5.4" then
    wanted_cells = {
      ["{__name = \"Vector2D\",x = 0,y = 2}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 0}"] = true,
    }
  elseif _VERSION == "Lua 5.3" or _VERSION == "Lua 5.2" then
    wanted_cells = { ["{__name = \"Vector2D\",x = 1,y = 1}"] = true }
  elseif _VERSION == "Lua 5.1" then
    if type(jit) == "table" then -- check for LuaJIT
      wanted_cells = {
        ["{__name = \"Vector2D\",x = 1,y = 0}"] = true,
        ["{__name = \"Vector2D\",x = 1,y = 1}"] = true,
        ["{__name = \"Vector2D\",x = 2,y = 1}"] = true,
      }
    else
      wanted_cells = { ["{__name = \"Vector2D\",x = 2,y = 1}"] = true }
    end
  end

  luaunit.assert_true(checks.is_instance(field, Field))

  luaunit.assert_true(checks.is_instance(field.size, Size))
  luaunit.assert_is(field.size, sample.size)

  luaunit.assert_true(checks.is_instance(field.bounds, BoundingBox))
  luaunit.assert_equals(field.bounds, BoundingBox:new(
    Vector2D:new(0, 0),
    Vector2D:new(2, 2)
  ))

  luaunit.assert_is_table(field._cells)
  luaunit.assert_equals(field._cells, wanted_cells)
end

function TestRandom.test_generate_large()
  math.randomseed(1)

  local sample = Field:new(Size:new(3, 3))
  local field = random.generate(sample, 0.8)

  local wanted_cells
  if _VERSION == "Lua 5.5" or _VERSION == "Lua 5.4" then
    wanted_cells = {
      ["{__name = \"Vector2D\",x = 0,y = 1}"] = true,
      ["{__name = \"Vector2D\",x = 0,y = 2}"] = true,
      ["{__name = \"Vector2D\",x = 1,y = 1}"] = true,
      ["{__name = \"Vector2D\",x = 1,y = 2}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 0}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 2}"] = true,
    }
  elseif _VERSION == "Lua 5.3" or _VERSION == "Lua 5.2" then
    wanted_cells = {
      ["{__name = \"Vector2D\",x = 0,y = 0}"] = true,
      ["{__name = \"Vector2D\",x = 0,y = 2}"] = true,
      ["{__name = \"Vector2D\",x = 1,y = 0}"] = true,
      ["{__name = \"Vector2D\",x = 1,y = 1}"] = true,
      ["{__name = \"Vector2D\",x = 1,y = 2}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 0}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 1}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 2}"] = true,
    }
  elseif _VERSION == "Lua 5.1" then
    if type(jit) == "table" then -- check for LuaJIT
      wanted_cells = {
        ["{__name = \"Vector2D\",x = 0,y = 0}"] = true,
        ["{__name = \"Vector2D\",x = 0,y = 1}"] = true,
        ["{__name = \"Vector2D\",x = 0,y = 2}"] = true,
        ["{__name = \"Vector2D\",x = 1,y = 0}"] = true,
        ["{__name = \"Vector2D\",x = 1,y = 1}"] = true,
        ["{__name = \"Vector2D\",x = 2,y = 1}"] = true,
      }
    else
      wanted_cells = {
        ["{__name = \"Vector2D\",x = 0,y = 1}"] = true,
        ["{__name = \"Vector2D\",x = 0,y = 2}"] = true,
        ["{__name = \"Vector2D\",x = 1,y = 0}"] = true,
        ["{__name = \"Vector2D\",x = 1,y = 2}"] = true,
        ["{__name = \"Vector2D\",x = 2,y = 0}"] = true,
        ["{__name = \"Vector2D\",x = 2,y = 1}"] = true,
        ["{__name = \"Vector2D\",x = 2,y = 2}"] = true,
      }
    end
  end

  luaunit.assert_true(checks.is_instance(field, Field))

  luaunit.assert_true(checks.is_instance(field.size, Size))
  luaunit.assert_is(field.size, sample.size)

  luaunit.assert_true(checks.is_instance(field.bounds, BoundingBox))
  luaunit.assert_equals(field.bounds, BoundingBox:new(
    Vector2D:new(0, 0),
    Vector2D:new(2, 2)
  ))

  luaunit.assert_is_table(field._cells)
  luaunit.assert_equals(field._cells, wanted_cells)
end

function TestRandom.test_generate_placed()
  math.randomseed(1)

  local sample = PlacedField:new(Size:new(3, 3), Vector2D:new(23, 42))
  local field = random.generate(sample, 0.8)

  local wanted_cells
  if _VERSION == "Lua 5.5" or _VERSION == "Lua 5.4" then
    wanted_cells = {
      ["{__name = \"Vector2D\",x = 0,y = 1}"] = true,
      ["{__name = \"Vector2D\",x = 0,y = 2}"] = true,
      ["{__name = \"Vector2D\",x = 1,y = 1}"] = true,
      ["{__name = \"Vector2D\",x = 1,y = 2}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 0}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 2}"] = true,
    }
  elseif _VERSION == "Lua 5.3" or _VERSION == "Lua 5.2" then
    wanted_cells = {
      ["{__name = \"Vector2D\",x = 0,y = 0}"] = true,
      ["{__name = \"Vector2D\",x = 0,y = 2}"] = true,
      ["{__name = \"Vector2D\",x = 1,y = 0}"] = true,
      ["{__name = \"Vector2D\",x = 1,y = 1}"] = true,
      ["{__name = \"Vector2D\",x = 1,y = 2}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 0}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 1}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 2}"] = true,
    }
  elseif _VERSION == "Lua 5.1" then
    if type(jit) == "table" then -- check for LuaJIT
      wanted_cells = {
        ["{__name = \"Vector2D\",x = 0,y = 0}"] = true,
        ["{__name = \"Vector2D\",x = 0,y = 1}"] = true,
        ["{__name = \"Vector2D\",x = 0,y = 2}"] = true,
        ["{__name = \"Vector2D\",x = 1,y = 0}"] = true,
        ["{__name = \"Vector2D\",x = 1,y = 1}"] = true,
        ["{__name = \"Vector2D\",x = 2,y = 1}"] = true,
      }
    else
      wanted_cells = {
        ["{__name = \"Vector2D\",x = 0,y = 1}"] = true,
        ["{__name = \"Vector2D\",x = 0,y = 2}"] = true,
        ["{__name = \"Vector2D\",x = 1,y = 0}"] = true,
        ["{__name = \"Vector2D\",x = 1,y = 2}"] = true,
        ["{__name = \"Vector2D\",x = 2,y = 0}"] = true,
        ["{__name = \"Vector2D\",x = 2,y = 1}"] = true,
        ["{__name = \"Vector2D\",x = 2,y = 2}"] = true,
      }
    end
  end

  luaunit.assert_true(checks.is_instance(field, PlacedField))

  luaunit.assert_true(checks.is_instance(field.size, Size))
  luaunit.assert_is(field.size, sample.size)

  luaunit.assert_true(checks.is_instance(field.local_bounds, BoundingBox))
  luaunit.assert_equals(field.local_bounds, BoundingBox:new(
    Vector2D:new(0, 0),
    Vector2D:new(2, 2)
  ))

  luaunit.assert_true(checks.is_instance(field.bounds, BoundingBox))
  luaunit.assert_equals(field.bounds, BoundingBox:new(
    Vector2D:new(23, 42),
    Vector2D:new(25, 44)
  ))

  luaunit.assert_true(checks.is_instance(field.offset, Vector2D))
  luaunit.assert_is(field.offset, sample.offset)

  luaunit.assert_is_table(field._cells)
  luaunit.assert_equals(field._cells, wanted_cells)
end

function TestRandom.test_generate_partial()
  math.randomseed(1)

  local sample = Field:new(Size:new(3, 3))
  local field = random.generate(sample)

  local wanted_cells
  if _VERSION == "Lua 5.5" or _VERSION == "Lua 5.4" then
    wanted_cells = {
      ["{__name = \"Vector2D\",x = 0,y = 1}"] = true,
      ["{__name = \"Vector2D\",x = 0,y = 2}"] = true,
      ["{__name = \"Vector2D\",x = 1,y = 2}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 0}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 2}"] = true,
    }
  elseif _VERSION == "Lua 5.3" or _VERSION == "Lua 5.2" then
    wanted_cells = {
      ["{__name = \"Vector2D\",x = 0,y = 0}"] = true,
      ["{__name = \"Vector2D\",x = 1,y = 1}"] = true,
      ["{__name = \"Vector2D\",x = 1,y = 2}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 1}"] = true,
    }
  elseif _VERSION == "Lua 5.1" then
    if type(jit) == "table" then -- check for LuaJIT
      wanted_cells = {
        ["{__name = \"Vector2D\",x = 0,y = 0}"] = true,
        ["{__name = \"Vector2D\",x = 0,y = 1}"] = true,
        ["{__name = \"Vector2D\",x = 0,y = 2}"] = true,
        ["{__name = \"Vector2D\",x = 1,y = 0}"] = true,
        ["{__name = \"Vector2D\",x = 1,y = 1}"] = true,
        ["{__name = \"Vector2D\",x = 2,y = 1}"] = true,
      }
    else
      wanted_cells = {
        ["{__name = \"Vector2D\",x = 0,y = 2}"] = true,
        ["{__name = \"Vector2D\",x = 1,y = 0}"] = true,
        ["{__name = \"Vector2D\",x = 2,y = 1}"] = true,
        ["{__name = \"Vector2D\",x = 2,y = 2}"] = true,
      }
    end
  end

  luaunit.assert_true(checks.is_instance(field, Field))

  luaunit.assert_true(checks.is_instance(field.size, Size))
  luaunit.assert_is(field.size, sample.size)

  luaunit.assert_true(checks.is_instance(field.bounds, BoundingBox))
  luaunit.assert_equals(field.bounds, BoundingBox:new(
    Vector2D:new(0, 0),
    Vector2D:new(2, 2)
  ))

  luaunit.assert_is_table(field._cells)
  luaunit.assert_equals(field._cells, wanted_cells)
end

function TestRandom.test_generate_with_limits_small()
  math.randomseed(1)

  local sample = Field:new(Size:new(3, 3))
  local field = random.generate_with_limits(sample, 0.5, Range:new(1, 1))

  local wanted_cells
  if _VERSION == "Lua 5.5" or _VERSION == "Lua 5.4" then
    wanted_cells = { ["{__name = \"Vector2D\",x = 0,y = 1}"] = true }
  elseif _VERSION == "Lua 5.3" or _VERSION == "Lua 5.2" then
    wanted_cells = { ["{__name = \"Vector2D\",x = 1,y = 1}"] = true }
  elseif _VERSION == "Lua 5.1" then
    wanted_cells = { ["{__name = \"Vector2D\",x = 2,y = 1}"] = true }
  end

  luaunit.assert_true(checks.is_instance(field, Field))

  luaunit.assert_true(checks.is_instance(field.size, Size))
  luaunit.assert_is(field.size, sample.size)

  luaunit.assert_true(checks.is_instance(field.bounds, BoundingBox))
  luaunit.assert_equals(field.bounds, BoundingBox:new(
    Vector2D:new(0, 0),
    Vector2D:new(2, 2)
  ))

  luaunit.assert_is_table(field._cells)
  luaunit.assert_equals(field._cells, wanted_cells)
end

function TestRandom.test_generate_with_limits_large()
  math.randomseed(1)

  local sample = Field:new(Size:new(3, 3))
  local field = random.generate_with_limits(sample, 0.5, Range:new(8, 8))

  local wanted_cells
  if _VERSION == "Lua 5.5" or _VERSION == "Lua 5.4" then
    wanted_cells = {
      ["{__name = \"Vector2D\",x = 0,y = 0}"] = true,
      ["{__name = \"Vector2D\",x = 0,y = 1}"] = true,
      ["{__name = \"Vector2D\",x = 0,y = 2}"] = true,
      ["{__name = \"Vector2D\",x = 1,y = 0}"] = true,
      ["{__name = \"Vector2D\",x = 1,y = 2}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 0}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 1}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 2}"] = true,
    }
  elseif _VERSION == "Lua 5.3" or _VERSION == "Lua 5.2" then
    wanted_cells = {
      ["{__name = \"Vector2D\",x = 0,y = 0}"] = true,
      ["{__name = \"Vector2D\",x = 0,y = 1}"] = true,
      ["{__name = \"Vector2D\",x = 0,y = 2}"] = true,
      ["{__name = \"Vector2D\",x = 1,y = 1}"] = true,
      ["{__name = \"Vector2D\",x = 1,y = 2}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 0}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 1}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 2}"] = true,
    }
  elseif _VERSION == "Lua 5.1" then
    if type(jit) == "table" then -- check for LuaJIT
      wanted_cells = {
        ["{__name = \"Vector2D\",x = 0,y = 0}"] = true,
        ["{__name = \"Vector2D\",x = 0,y = 1}"] = true,
        ["{__name = \"Vector2D\",x = 0,y = 2}"] = true,
        ["{__name = \"Vector2D\",x = 1,y = 0}"] = true,
        ["{__name = \"Vector2D\",x = 1,y = 1}"] = true,
        ["{__name = \"Vector2D\",x = 1,y = 2}"] = true,
        ["{__name = \"Vector2D\",x = 2,y = 0}"] = true,
        ["{__name = \"Vector2D\",x = 2,y = 2}"] = true,
      }
    else
      wanted_cells = {
        ["{__name = \"Vector2D\",x = 0,y = 0}"] = true,
        ["{__name = \"Vector2D\",x = 0,y = 1}"] = true,
        ["{__name = \"Vector2D\",x = 0,y = 2}"] = true,
        ["{__name = \"Vector2D\",x = 1,y = 0}"] = true,
        ["{__name = \"Vector2D\",x = 1,y = 1}"] = true,
        ["{__name = \"Vector2D\",x = 1,y = 2}"] = true,
        ["{__name = \"Vector2D\",x = 2,y = 1}"] = true,
        ["{__name = \"Vector2D\",x = 2,y = 2}"] = true,
      }
    end
  end

  luaunit.assert_true(checks.is_instance(field, Field))

  luaunit.assert_true(checks.is_instance(field.size, Size))
  luaunit.assert_is(field.size, sample.size)

  luaunit.assert_true(checks.is_instance(field.bounds, BoundingBox))
  luaunit.assert_equals(field.bounds, BoundingBox:new(
    Vector2D:new(0, 0),
    Vector2D:new(2, 2)
  ))

  luaunit.assert_is_table(field._cells)
  luaunit.assert_equals(field._cells, wanted_cells)
end

function TestRandom.test_generate_with_limits_placed()
  math.randomseed(1)

  local sample = PlacedField:new(Size:new(3, 3), Vector2D:new(23, 42))
  local field = random.generate_with_limits(sample, 0.5, Range:new(8, 8))

  local wanted_cells
  if _VERSION == "Lua 5.5" or _VERSION == "Lua 5.4" then
    wanted_cells = {
      ["{__name = \"Vector2D\",x = 0,y = 0}"] = true,
      ["{__name = \"Vector2D\",x = 0,y = 1}"] = true,
      ["{__name = \"Vector2D\",x = 0,y = 2}"] = true,
      ["{__name = \"Vector2D\",x = 1,y = 0}"] = true,
      ["{__name = \"Vector2D\",x = 1,y = 2}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 0}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 1}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 2}"] = true,
    }
  elseif _VERSION == "Lua 5.3" or _VERSION == "Lua 5.2" then
    wanted_cells = {
      ["{__name = \"Vector2D\",x = 0,y = 0}"] = true,
      ["{__name = \"Vector2D\",x = 0,y = 1}"] = true,
      ["{__name = \"Vector2D\",x = 0,y = 2}"] = true,
      ["{__name = \"Vector2D\",x = 1,y = 1}"] = true,
      ["{__name = \"Vector2D\",x = 1,y = 2}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 0}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 1}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 2}"] = true,
    }
  elseif _VERSION == "Lua 5.1" then
    if type(jit) == "table" then -- check for LuaJIT
      wanted_cells = {
        ["{__name = \"Vector2D\",x = 0,y = 0}"] = true,
        ["{__name = \"Vector2D\",x = 0,y = 1}"] = true,
        ["{__name = \"Vector2D\",x = 0,y = 2}"] = true,
        ["{__name = \"Vector2D\",x = 1,y = 0}"] = true,
        ["{__name = \"Vector2D\",x = 1,y = 1}"] = true,
        ["{__name = \"Vector2D\",x = 1,y = 2}"] = true,
        ["{__name = \"Vector2D\",x = 2,y = 0}"] = true,
        ["{__name = \"Vector2D\",x = 2,y = 2}"] = true,
      }
    else
      wanted_cells = {
        ["{__name = \"Vector2D\",x = 0,y = 0}"] = true,
        ["{__name = \"Vector2D\",x = 0,y = 1}"] = true,
        ["{__name = \"Vector2D\",x = 0,y = 2}"] = true,
        ["{__name = \"Vector2D\",x = 1,y = 0}"] = true,
        ["{__name = \"Vector2D\",x = 1,y = 1}"] = true,
        ["{__name = \"Vector2D\",x = 1,y = 2}"] = true,
        ["{__name = \"Vector2D\",x = 2,y = 1}"] = true,
        ["{__name = \"Vector2D\",x = 2,y = 2}"] = true,
      }
    end
  end

  luaunit.assert_true(checks.is_instance(field, PlacedField))

  luaunit.assert_true(checks.is_instance(field.size, Size))
  luaunit.assert_is(field.size, sample.size)

  luaunit.assert_true(checks.is_instance(field.local_bounds, BoundingBox))
  luaunit.assert_equals(field.local_bounds, BoundingBox:new(
    Vector2D:new(0, 0),
    Vector2D:new(2, 2)
  ))

  luaunit.assert_true(checks.is_instance(field.bounds, BoundingBox))
  luaunit.assert_equals(field.bounds, BoundingBox:new(
    Vector2D:new(23, 42),
    Vector2D:new(25, 44)
  ))

  luaunit.assert_true(checks.is_instance(field.offset, Vector2D))
  luaunit.assert_is(field.offset, sample.offset)

  luaunit.assert_is_table(field._cells)
  luaunit.assert_equals(field._cells, wanted_cells)
end

function TestRandom.test_generate_with_limits_partial()
  math.randomseed(1)

  local sample = Field:new(Size:new(3, 3))
  local field = random.generate_with_limits(sample)

  local wanted_cells
  if _VERSION == "Lua 5.5" or _VERSION == "Lua 5.4" then
    wanted_cells = {
      ["{__name = \"Vector2D\",x = 0,y = 1}"] = true,
      ["{__name = \"Vector2D\",x = 0,y = 2}"] = true,
      ["{__name = \"Vector2D\",x = 1,y = 2}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 0}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 2}"] = true,
    }
  elseif _VERSION == "Lua 5.3" or _VERSION == "Lua 5.2" then
    wanted_cells = {
      ["{__name = \"Vector2D\",x = 0,y = 0}"] = true,
      ["{__name = \"Vector2D\",x = 1,y = 1}"] = true,
      ["{__name = \"Vector2D\",x = 1,y = 2}"] = true,
      ["{__name = \"Vector2D\",x = 2,y = 1}"] = true,
    }
  elseif _VERSION == "Lua 5.1" then
    if type(jit) == "table" then -- check for LuaJIT
      wanted_cells = {
        ["{__name = \"Vector2D\",x = 0,y = 0}"] = true,
        ["{__name = \"Vector2D\",x = 0,y = 1}"] = true,
        ["{__name = \"Vector2D\",x = 0,y = 2}"] = true,
        ["{__name = \"Vector2D\",x = 1,y = 0}"] = true,
        ["{__name = \"Vector2D\",x = 1,y = 1}"] = true,
        ["{__name = \"Vector2D\",x = 2,y = 1}"] = true,
      }
    else
      wanted_cells = {
        ["{__name = \"Vector2D\",x = 0,y = 2}"] = true,
        ["{__name = \"Vector2D\",x = 1,y = 0}"] = true,
        ["{__name = \"Vector2D\",x = 2,y = 1}"] = true,
        ["{__name = \"Vector2D\",x = 2,y = 2}"] = true,
      }
    end
  end

  luaunit.assert_true(checks.is_instance(field, Field))

  luaunit.assert_true(checks.is_instance(field.size, Size))
  luaunit.assert_is(field.size, sample.size)

  luaunit.assert_true(checks.is_instance(field.bounds, BoundingBox))
  luaunit.assert_equals(field.bounds, BoundingBox:new(
    Vector2D:new(0, 0),
    Vector2D:new(2, 2)
  ))

  luaunit.assert_is_table(field._cells)
  luaunit.assert_equals(field._cells, wanted_cells)
end
