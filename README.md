# lualife

[![doc:build](https://github.com/thewizardplusplus/lualife/actions/workflows/doc.yaml/badge.svg)](https://github.com/thewizardplusplus/lualife/actions/workflows/doc.yaml)
[![doc:link](https://img.shields.io/badge/doc%3Alink-link-blue?logo=github)](https://thewizardplusplus.github.io/lualife/)
[![lint](https://github.com/thewizardplusplus/lualife/actions/workflows/lint.yaml/badge.svg)](https://github.com/thewizardplusplus/lualife/actions/workflows/lint.yaml)
[![test](https://github.com/thewizardplusplus/lualife/actions/workflows/test.yaml/badge.svg)](https://github.com/thewizardplusplus/lualife/actions/workflows/test.yaml)
[![bench](https://github.com/thewizardplusplus/lualife/actions/workflows/bench.yaml/badge.svg)](https://github.com/thewizardplusplus/lualife/actions/workflows/bench.yaml)
[![luarocks](https://img.shields.io/badge/luarocks-link-blue?logo=lua)](https://luarocks.org/modules/thewizardplusplus/lualife)

The library that implements [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway's_Game_of_Life).

_**Disclaimer:** this library was written directly on an Android smartphone with the [QLua](https://play.google.com/store/apps/details?id=com.quseit.qlua5pro2) IDE._

## Features

- models:
  - field:
    - using the `Vector2D`, `Size`, and `BoundingBox` classes from the
      [luamath](https://github.com/thewizardplusplus/luamath) library;
    - storing its cell bounds as a bounding box;
    - storing only of set cells:
      - ignore outside points;
    - supporting of counting of set cells;
    - supporting of checking if a cell is set:
      - ignore outside points;
    - supporting of checking if an other field fits inside;
    - supporting of mapping;
    - serialization via the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library:
      - exposing a class name and a stringified representation;
      - generating a JSON Schema via the `schema()` static method;
      - constructing an instance from serializable options via the `from_options()` static method;
  - placed field:
    - extends the field model;
    - storing a field offset in its bounds;
    - working with cells taking into account the field offset;
    - supporting of checking if an other field with offset fits inside;
    - supporting of copying the existing field with setting an offset;
    - serialization via the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library:
      - exposing a class name and a stringified representation;
      - generating a JSON Schema via the `schema()` static method;
      - constructing an instance from serializable options via the `from_options()` static method;
- generating of a random field:
  - customizable filling factor;
  - limiting the cell count with the `Range` class from the
    [luamath](https://github.com/thewizardplusplus/luamath) library;
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

```
$ luarocks install lualife
```

## Examples

`lualife.sets`:

```lua
local assertions = require("luatypechecks.assertions")
local Vector2D = require("luamath.vector2d")
local Size = require("luamath.models.size")
local PlacedField = require("lualife.models.placedfield")
local sets = require("lualife.sets")

local function print_field(field)
  assertions.is_instance(field, PlacedField)

  field:map(function(point, contains)
    assertions.is_instance(point, Vector2D)
    assertions.is_boolean(contains)

    io.write(contains and "O" or ".")

    if point.x - field:offset().x == field.size.width - 1 then
      io.write("\n")
    end
  end)

  io.write("\n")
end

local glider = PlacedField:new(Size:new(3, 3), Vector2D:new(2, 2))
glider:set(Vector2D:new(3, 2))
glider:set(Vector2D:new(4, 3))
glider:set(Vector2D:new(2, 4))
glider:set(Vector2D:new(3, 4))
glider:set(Vector2D:new(4, 4))

local blinker = PlacedField:new(Size:new(3, 3), Vector2D:new(1, 2))
blinker:set(Vector2D:new(2, 2))
blinker:set(Vector2D:new(2, 3))
blinker:set(Vector2D:new(2, 4))

local unioned_field = sets.union(glider, blinker)
print_field(unioned_field)

local complemented_field = sets.complement(glider, blinker)
print_field(complemented_field)

local intersected_field = sets.intersection(glider, blinker)
print_field(intersected_field)
```

`lualife.matrix.rotate()`:

```lua
local assertions = require("luatypechecks.assertions")
local Vector2D = require("luamath.vector2d")
local Size = require("luamath.models.size")
local Field = require("lualife.models.field")
local matrix = require("lualife.matrix")

local function print_field(field)
  assertions.is_instance(field, Field)

  field:map(function(point, contains)
    assertions.is_instance(point, Vector2D)
    assertions.is_boolean(contains)

    io.write(contains and "O" or ".")

    if point.x == field.size.width - 1 then
      io.write("\n")
    end
  end)
end

local field = Field:new(Size:new(3, 3))
field:set(Vector2D:new(1, 0))
field:set(Vector2D:new(2, 1))
field:set(Vector2D:new(0, 2))
field:set(Vector2D:new(1, 2))
field:set(Vector2D:new(2, 2))

local rotated_field = matrix.rotate(field)
print_field(rotated_field)
```

`lualife.life.populate()`:

```lua
local assertions = require("luatypechecks.assertions")
local Vector2D = require("luamath.vector2d")
local Size = require("luamath.models.size")
local Field = require("lualife.models.field")
local life = require("lualife.life")

local function print_field(field)
  assertions.is_instance(field, Field)

  field:map(function(point, contains)
    assertions.is_instance(point, Vector2D)
    assertions.is_boolean(contains)

    io.write(contains and "O" or ".")

    if point.x == field.size.width - 1 then
      io.write("\n")
    end
  end)
end

local function sleep(seconds)
  assertions.is_number(seconds)

  local start = os.clock()
  while os.clock() - start < seconds do end
end

local field = Field:new(Size:new(3, 3))
field:set(Vector2D:new(0, 1))
field:set(Vector2D:new(1, 1))
field:set(Vector2D:new(2, 1))

while true do
  field = life.populate(field)
  print_field(field)
  sleep(0.2)
end
```

`lualife.random.generate()`:

```lua
local assertions = require("luatypechecks.assertions")
local Vector2D = require("luamath.vector2d")
local Size = require("luamath.models.size")
local Field = require("lualife.models.field")
local random = require("lualife.random")
local life = require("lualife.life")

local function print_field(field)
  assertions.is_instance(field, Field)

  field:map(function(point, contains)
    assertions.is_instance(point, Vector2D)
    assertions.is_boolean(contains)

    io.write(contains and "O" or ".")

    if point.x == field.size.width - 1 then
      io.write("\n")
    end
  end)
end

local function sleep(seconds)
  assertions.is_number(seconds)

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

## Benchmarks

```
Benchmarks (Lua 5.4, chronos clock, 5 rounds)
=============================================

[[field_bench.lua]]
-------------------
Field:contains() x25 (5x5)                         time: 808us ± 34us             memory: 54kB ± 32B
Field:contains() x100 (10x10)                      time: 3ms ± 61us               memory: 71kB
Field:contains() x400 (20x20)                      time: 13ms ± 133us             memory: 78kB
Field:contains() x1600 (40x40)                     time: 52ms ± 778us             memory: 133kB ± 60B
Field:count() (5x5, 20% alive)                     time: 526ns ± 486ns            memory: 0B
Field:count() (10x10, 20% alive)                   time: 1us ± 646ns              memory: 0B
Field:count() (20x20, 20% alive)                   time: 4us ± 749ns              memory: 0B
Field:count() (40x40, 20% alive)                   time: 16us ± 1us               memory: 0B
Field:fits() (5x5 in 7x7)                          time: 4us ± 2us                memory: 0B
Field:fits() (10x10 in 12x12)                      time: 6us ± 18us               memory: 0B
Field:fits() (20x20 in 22x22)                      time: 4us ± 2us                memory: 0B
Field:fits() (40x40 in 42x42)                      time: 4us ± 2us                memory: 0B
json.from_json(Field) (5x5, 20% alive)             time: 1ms ± 23us               memory: 88kB ± 32B
json.from_json(Field) (10x10, 20% alive)           time: 2ms ± 45us               memory: 143kB
json.from_json(Field) (20x20, 20% alive)           time: 6ms ± 34us               memory: 85kB
json.from_json(Field) (40x40, 20% alive)           time: 22ms ± 342us             memory: 289kB ± 108B
Field:map() copy (5x5, 20% alive)                  time: 1ms ± 46us               memory: 78kB
Field:map() copy (10x10, 20% alive)                time: 5ms ± 29us               memory: 153kB
Field:map() copy (20x20, 20% alive)                time: 18ms ± 100us             memory: 135kB
Field:map() copy (40x40, 20% alive)                time: 74ms ± 1ms               memory: 173kB
Field:set() x5 (5x5)                               time: 218us ± 10us             memory: 14kB
Field:set() x20 (10x10)                            time: 697us ± 121us            memory: 46kB
Field:set() x80 (20x20)                            time: 3ms ± 39us               memory: 25kB
Field:set() x320 (40x40)                           time: 10ms ± 64us              memory: 36kB
tostring(Field) (5x5, 20% alive)                   time: 1ms ± 39us               memory: 83kB ± 32B
tostring(Field) (10x10, 20% alive)                 time: 5ms ± 73us               memory: 150kB
tostring(Field) (20x20, 20% alive)                 time: 18ms ± 107us             memory: 109kB ± 72B
tostring(Field) (40x40, 20% alive)                 time: 74ms ± 1ms               memory: 304kB

[[life_bench.lua]]
------------------
life.populate(Field) (5x5, 20% alive)              time: 10ms ± 279us             memory: 150kB
life.populate(Field) (10x10, 20% alive)            time: 44ms ± 85us              memory: 60kB ± 60B
life.populate(Field) (20x20, 20% alive)            time: 188ms ± 4ms              memory: 29kB ± 1kB
life.populate(Field) (40x40, 20% alive)            time: 766ms ± 15ms             memory: 119kB ± 3kB
life.populate(PlacedField) (5x5, 20% alive)        time: 26ms ± 98us              memory: 23kB
life.populate(PlacedField) (10x10, 20% alive)      time: 109ms ± 2ms              memory: 118kB
life.populate(PlacedField) (20x20, 20% alive)      time: 453ms ± 7ms              memory: 134kB
life.populate(PlacedField) (40x40, 20% alive)      time: 2s ± 26ms                memory: 11kB ± 75kB

[[matrix_bench.lua]]
--------------------
matrix.rotate(Field) (5x5, 20% alive)              time: 3ms ± 646us              memory: 9kB ± 104B
matrix.rotate(Field) (10x10, 20% alive)            time: 9ms ± 85us               memory: 132kB
matrix.rotate(Field) (20x20, 20% alive)            time: 36ms ± 223us             memory: 135kB ± 60B
matrix.rotate(Field) (40x40, 20% alive)            time: 142ms ± 188us            memory: 127kB
matrix.rotate(PlacedField) (5x5, 20% alive)        time: 9ms ± 1ms                memory: 67kB ± 32B
matrix.rotate(PlacedField) (10x10, 20% alive)      time: 34ms ± 248us             memory: 22kB ± 1kB
matrix.rotate(PlacedField) (20x20, 20% alive)      time: 135ms ± 150us            memory: 38kB
matrix.rotate(PlacedField) (40x40, 20% alive)      time: 541ms ± 454us            memory: 139kB ± 4kB

[[placedfield_bench.lua]]
-------------------------
PlacedField:contains() x25 (5x5)                   time: 2ms ± 75us               memory: 127kB
PlacedField:contains() x100 (10x10)                time: 8ms ± 71us               memory: 41kB
PlacedField:contains() x400 (20x20)                time: 33ms ± 84us              memory: 33kB
PlacedField:contains() x1600 (40x40)               time: 134ms ± 224us            memory: 112kB ± 908B
PlacedField:count() (5x5, 20% alive)               time: 539ns ± 497ns            memory: 0B
PlacedField:count() (10x10, 20% alive)             time: 2us ± 504ns              memory: 0B
PlacedField:count() (20x20, 20% alive)             time: 4us ± 831ns              memory: 0B
PlacedField:count() (40x40, 20% alive)             time: 16us ± 2us               memory: 0B
PlacedField:fits() (5x5 in 7x7)                    time: 7us ± 2us                memory: 0B
PlacedField:fits() (10x10 in 12x12)                time: 9us ± 2us                memory: 0B
PlacedField:fits() (20x20 in 22x22)                time: 7us ± 2us                memory: 0B
PlacedField:fits() (40x40 in 42x42)                time: 7us ± 2us                memory: 0B
json.from_json(PlacedField) (5x5, 20% alive)       time: 2ms ± 685us              memory: 133kB ± 32B
json.from_json(PlacedField) (10x10, 20% alive)     time: 4ms ± 120us              memory: 94kB
json.from_json(PlacedField) (20x20, 20% alive)     time: 11ms ± 268us             memory: 184kB
json.from_json(PlacedField) (40x40, 20% alive)     time: 39ms ± 151us             memory: 306kB ± 36B
PlacedField:map() copy (5x5, 20% alive)            time: 7ms ± 1ms                memory: 87kB
PlacedField:map() copy (10x10, 20% alive)          time: 26ms ± 114us             memory: 140kB
PlacedField:map() copy (20x20, 20% alive)          time: 102ms ± 266us            memory: 139kB ± 782B
PlacedField:map() copy (40x40, 20% alive)          time: 409ms ± 2ms              memory: 181kB ± 1kB
PlacedField:offset() (5x5)                         time: 288ns ± 374ns            memory: 0B
PlacedField:offset() (10x10)                       time: 381ns ± 547ns            memory: 0B
PlacedField:offset() (20x20)                       time: 275ns ± 334ns            memory: 0B
PlacedField:offset() (40x40)                       time: 249ns ± 323ns            memory: 0B
PlacedField.place() (5x5, 20% alive)               time: 2ms ± 957us              memory: 110kB
PlacedField.place() (10x10, 20% alive)             time: 7ms ± 46us               memory: 113kB
PlacedField.place() (20x20, 20% alive)             time: 27ms ± 412us             memory: 92kB ± 846B
PlacedField.place() (40x40, 20% alive)             time: 106ms ± 156us            memory: 53kB
PlacedField:set() x5 (5x5)                         time: 525us ± 19us             memory: 30kB
PlacedField:set() x20 (10x10)                      time: 2ms ± 67us               memory: 107kB
PlacedField:set() x80 (20x20)                      time: 7ms ± 68us               memory: 100kB
PlacedField:set() x320 (40x40)                     time: 27ms ± 441us             memory: 104kB ± 260B
tostring(PlacedField) (5x5, 20% alive)             time: 6ms ± 2ms                memory: 58kB ± 32B
tostring(PlacedField) (10x10, 20% alive)           time: 23ms ± 81us              memory: 148kB
tostring(PlacedField) (20x20, 20% alive)           time: 91ms ± 64us              memory: 97kB ± 412B
tostring(PlacedField) (40x40, 20% alive)           time: 365ms ± 59us             memory: 282kB ± 1kB

[[random_bench.lua]]
--------------------
random.generate() (5x5, filling: 20%)              time: 1ms ± 62us               memory: 78kB ± 4kB
random.generate() (10x10, filling: 20%)            time: 5ms ± 179us              memory: 151kB ± 4kB
random.generate() (20x20, filling: 20%)            time: 18ms ± 145us             memory: 116kB ± 17kB
random.generate() (40x40, filling: 20%)            time: 71ms ± 833us             memory: 136kB ± 45kB
random.generate_with_limits() (5x5, filling: 20%, 18..22% alive)
                                                   time: 1ms ± 654us              memory: 78kB ± 1kB
random.generate_with_limits() (10x10, filling: 20%, 18..22% alive)
                                                   time: 9ms ± 9ms                memory: 151kB ± 58kB
random.generate_with_limits() (20x20, filling: 20%, 18..22% alive)
                                                   time: 18ms ± 297us             memory: 114kB ± 13kB
random.generate_with_limits() (40x40, filling: 20%, 18..22% alive)
                                                   time: 71ms ± 35ms              memory: 133kB ± 48kB

[[sets_bench.lua]]
------------------
sets.complement() (5x5, base: 20% alive, additional: 33.3333% alive)
                                                   time: 2ms ± 568us              memory: 97kB
sets.complement() (10x10, base: 20% alive, additional: 33.3333% alive)
                                                   time: 6ms ± 104us              memory: 70kB
sets.complement() (20x20, base: 20% alive, additional: 33.3333% alive)
                                                   time: 24ms ± 321us             memory: 76kB ± 782B
sets.complement() (40x40, base: 20% alive, additional: 33.3333% alive)
                                                   time: 95ms ± 42us              memory: 169kB ± 1kB
sets.intersection() (5x5, base: 20% alive, additional: 33.3333% alive)
                                                   time: 2ms ± 88us               memory: 95kB
sets.intersection() (10x10, base: 20% alive, additional: 33.3333% alive)
                                                   time: 6ms ± 76us               memory: 44kB
sets.intersection() (20x20, base: 20% alive, additional: 33.3333% alive)
                                                   time: 22ms ± 347us             memory: 138kB ± 32B
sets.intersection() (40x40, base: 20% alive, additional: 33.3333% alive)
                                                   time: 90ms ± 302us             memory: 154kB ± 268B
sets.union() (5x5, base: 20% alive, additional: 33.3333% alive)
                                                   time: 3ms ± 687us              memory: 16kB
sets.union() (10x10, base: 20% alive, additional: 33.3333% alive)
                                                   time: 11ms ± 135us             memory: 62kB
sets.union() (20x20, base: 20% alive, additional: 33.3333% alive)
                                                   time: 44ms ± 256us             memory: 10kB ± 36B
sets.union() (40x40, base: 20% alive, additional: 33.3333% alive)
                                                   time: 178ms ± 432us            memory: 128kB ± 1kB
```

## License

The MIT License (MIT)

Copyright &copy; 2020, 2026 thewizardplusplus
