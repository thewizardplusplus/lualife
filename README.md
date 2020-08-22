# lualife

The library that implements [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway's_Game_of_Life).

## Features

- models:
  - size:
    - supporting of checking if a point is inside;
    - supporting of checking if an other size with offset fits inside;
  - point:
    - supporting of translation;
    - supporting of scaling;
    - supporting of textual representation;
  - field:
    - storing only of set cells:
      - ignore outside points;
    - supporting of counting of set cells;
    - supporting of checking if a cell is set:
      - ignore outside points;
    - supporting of checking if an other field fits inside;
    - supporting of mapping;
  - placed field:
    - extends the field model;
    - storing a field offset;
    - working with cells taking into account the field offset;
    - supporting of checking if an other field with offset fits inside;
    - supporting of copying the existing field with setting an offset;
- generating of a random field:
  - customizable filling factor;
  - limiting by a cell count:
    - lower limit;
    - upper limit;
- operations with fields as with sets:
  - union of fields:
    - supporting an offset for the second operand;
    - restricting of the result size by the size of the first operand;
  - complement of fields:
    - supporting an offset for the second operand;
  - intersection of fields:
    - supporting an offset for the second operand;
- operations with fields as with matrices:
  - rotating of a field clockwise;
- populating of a field according to [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway's_Game_of_Life) rules:
  - using of the naive algorithm with iterating and copying of a whole field.

## Installation

Clone this repository:

```
$ git clone https://github.com/thewizardplusplus/lualife.git
$ cd lualife
```

Install the library with the [LuaRocks](https://luarocks.org/) tool:

```
$ luarocks make
```

## Examples

`lualife.sets`:

```lua
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local PlacedField = require("lualife.models.placedfield")
local sets = require("lualife.sets")

local function print_field(field)
  assert(field.isInstanceOf and field:isInstanceOf(PlacedField))

  field:map(function(point, contains)
    io.write(contains and "O" or ".")

    if point.x - field.offset.x == field.size.width - 1 then
      io.write("\n")
    end
  end)

  io.write("\n")
end

local glider = PlacedField:new(Size:new(3, 3), Point:new(2, 2))
glider:set(Point:new(3, 2))
glider:set(Point:new(4, 3))
glider:set(Point:new(2, 4))
glider:set(Point:new(3, 4))
glider:set(Point:new(4, 4))

local blinker = PlacedField:new(Size:new(3, 3), Point:new(1, 2))
blinker:set(Point:new(2, 2))
blinker:set(Point:new(2, 3))
blinker:set(Point:new(2, 4))

local unioned_field = sets.union(glider, blinker)
print_field(unioned_field)

local complemented_field = sets.complement(glider, blinker)
print_field(complemented_field)

local intersected_field = sets.intersection(glider, blinker)
print_field(intersected_field)
```

`lualife.matrix.rotate()`:

```lua
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local Field = require("lualife.models.field")
local matrix = require("lualife.matrix")

local function print_field(field)
  assert(field.isInstanceOf and field:isInstanceOf(Field))

  field:map(function(point, contains)
    io.write(contains and "O" or ".")

    if point.x == field.size.width - 1 then
      io.write("\n")
    end
  end)
end

local field = Field:new(Size:new(3, 3))
field:set(Point:new(1, 0))
field:set(Point:new(2, 1))
field:set(Point:new(0, 2))
field:set(Point:new(1, 2))
field:set(Point:new(2, 2))

local rotated_field = matrix.rotate(field)
print_field(rotated_field)
```

`lualife.life.populate()`:

```lua
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local Field = require("lualife.models.field")
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

local field = Field:new(Size:new(3, 3))
field:set(Point:new(0, 1))
field:set(Point:new(1, 1))
field:set(Point:new(2, 1))

while true do
  field = life.populate(field)
  print_field(field)
  sleep(0.2)
end
```

`lualife.random.generate()`:

```lua
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
```

## License

The MIT License (MIT)

Copyright &copy; 2020 thewizardplusplus
