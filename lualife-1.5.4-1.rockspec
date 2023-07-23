rockspec_format = "3.0"
package = "lualife"
version = "1.5.4-1"
description = {
  summary = "The library that implements Conway's Game of Life.",
  license = "MIT",
  maintainer = "thewizardplusplus <thewizardplusplus@yandex.ru>",
  homepage = "https://github.com/thewizardplusplus/lualife",
}
source = {
  url = "git+https://github.com/thewizardplusplus/lualife.git",
  tag = "v1.5.4",
}
dependencies = {
  "lua >= 5.1",
  "middleclass >= 4.1.1, < 5.0",
  "inspect >= 3.1.1, < 4.0",
  "luatypechecks >= 1.3.4, < 2.0",
}
test_dependencies = {
  "luaunit >= 3.4, < 4.0",
}
build = {
  type = "builtin",
  modules = {
    ["lualife.types"] = "types.lua",
    ["lualife.types_test"] = "types_test.lua",
    ["lualife.random"] = "random.lua",
    ["lualife.random_test"] = "random_test.lua",
    ["lualife.sets"] = "sets.lua",
    ["lualife.sets_test"] = "sets_test.lua",
    ["lualife.matrix"] = "matrix.lua",
    ["lualife.matrix_test"] = "matrix_test.lua",
    ["lualife.life"] = "life.lua",
    ["lualife.life_test"] = "life_test.lua",
    ["lualife.models.stringifiable"] = "models/stringifiable.lua",
    ["lualife.models.stringifiable_test"] = "models/stringifiable_test.lua",
    ["lualife.models.size"] = "models/size.lua",
    ["lualife.models.size_test"] = "models/size_test.lua",
    ["lualife.models.point"] = "models/point.lua",
    ["lualife.models.point_test"] = "models/point_test.lua",
    ["lualife.models.field"] = "models/field.lua",
    ["lualife.models.field_test"] = "models/field_test.lua",
    ["lualife.models.placedfield"] = "models/placedfield.lua",
    ["lualife.models.placedfield_test"] = "models/placedfield_test.lua",
  },
  copy_directories = {
    "doc",
  },
}
