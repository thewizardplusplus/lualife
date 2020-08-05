# lualife

The library that implements [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway's_Game_of_Life).

## Features

- models:
  - size;
  - point:
    - supporting of translation;
    - supporting of scaling;
    - supporting of textual representation;
  - field:
    - storing only of set cells;
    - supporting of mapping;
- generating of random field:
  - customizable filling factor;
  - limiting by a cell count:
    - lower limit;
    - upper limit;
- operations with fields as with sets:
  - union of fields:
    - supporting an offset for the second operand;
    - restricting of the result size by the size of the first operand;
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

`lualife.life.populate()`:

```lua
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local Field = require("lualife.models.field")
local life = require("lualife.life")

local function print_field(field)
  assert(field:isInstanceOf(Field))

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
  assert(field:isInstanceOf(Field))

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

local field = random.generate(Size:new(10, 10), 0.5)
while true do
  field = life.populate(field)
  print_field(field)
  sleep(0.2)
end
```

## License

The MIT License (MIT)

Copyright &copy; 2020 thewizardplusplus
