# lualife

The library that implements [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway's_Game_of_Life).

## Features

- models:
  - size;
  - point:
    - supporting of translation;
    - supporting of textual representation;
  - field:
    - storing only of set cells;
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

  for y = 0, field.size.height - 1 do
    for x = 0, field.size.width - 1 do
      local point = Point:new(x, y)
      local alive = field:contains(point)
      io.write(alive and "O" or ".")
    end

    io.write("\n")
  end
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

## License

The MIT License (MIT)

Copyright &copy; 2020 thewizardplusplus
