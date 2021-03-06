# Change Log

## [v1.5.4](https://github.com/thewizardplusplus/lualife/tree/v1.5.4) (2020-08-30)

- adding of improved asserts:
  - checking of numbers:
    - with optional checking of a number range;
  - checking of callable values:
    - functions;
    - tables with the `__call()` metamethod;
  - checking of classes inheritance:
    - supporting of the [middleclass](https://github.com/kikito/middleclass) library.

## [v1.5.3](https://github.com/thewizardplusplus/lualife/tree/v1.5.3) (2020-08-24)

- generating of a random field:
  - supporting of default values for parameters:
    - filling factor;
    - cell count:
      - lower limit;
      - upper limit.

## [v1.5.2](https://github.com/thewizardplusplus/lualife/tree/v1.5.2) (2020-08-22)

- models:
  - size:
    - supporting of textual representation;
  - field:
    - supporting of textual representation;
  - placed field:
    - supporting of textual representation;
- refactoring:
  - extract the implementation of textual representations for models to a separate mixin;
  - improve error handling.

## [v1.5.1](https://github.com/thewizardplusplus/lualife/tree/v1.5.1) (2020-08-19)

- models:
  - size:
    - supporting of checking if a point is inside;
  - field:
    - ignore outside points:
      - on checking if a cell is set;
      - on storing a set cell;
- refactoring:
  - mark private class members of models:
    - properties;
    - methods;
  - extract examples to separate files;
- documentation:
  - describe properties of models;
  - add examples as separate pages.

## [v1.5](https://github.com/thewizardplusplus/lualife/tree/v1.5) (2020-08-18)

- models:
  - field:
    - supporting of checking if an other field fits inside;
  - placed field:
    - extends the field model;
    - storing a field offset;
    - working with cells taking into account the field offset;
    - supporting of checking if an other field with offset fits inside;
    - supporting of copying the existing field with setting an offset.

## [v1.4](https://github.com/thewizardplusplus/lualife/tree/v1.4) (2020-08-14)

- operations with fields as with matrices:
  - rotating of a field clockwise.

## [v1.3](https://github.com/thewizardplusplus/lualife/tree/v1.3) (2020-08-10)

- models:
  - size:
    - supporting of checking if an other size with offset fits inside;
  - field:
    - supporting of counting of set cells;
- operations with fields as with sets:
  - complement of fields:
    - supporting an offset for the second operand;
  - intersection of fields:
    - supporting an offset for the second operand.

## [v1.2](https://github.com/thewizardplusplus/lualife/tree/v1.2) (2020-08-05)

- generating of a random field:
  - limiting by a cell count:
    - lower limit;
    - upper limit;
- operations with fields as with sets:
  - union of fields:
    - supporting an offset for the second operand;
    - restricting of the result size by the size of the first operand.

## [v1.1](https://github.com/thewizardplusplus/lualife/tree/v1.1) (2020-08-02)

- models:
  - point:
    - supporting of scaling;
  - field:
    - supporting of mapping;
- generating of a random field:
  - customizable filling factor.

## [v1.0](https://github.com/thewizardplusplus/lualife/tree/v1.0) (2020-07-28)
