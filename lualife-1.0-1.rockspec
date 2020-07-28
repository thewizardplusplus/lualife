package = "lualife"
version = "1.0-1"
description = {
  license = "MIT",
  maintainer = "thewizardplusplus <thewizardplusplus@yandex.ru>",
  homepage = "https://github.com/thewizardplusplus/lualife",
}
source = {
  url = "git+https://github.com/thewizardplusplus/lualife.git",
  tag = "v1.0",
}
dependencies = {
  "lua >= 5.2, < 5.4",
  "middleclass >= 4.1.1, < 5.0",
}
build = {
  type = "builtin",
  modules = {
    ["life"] = "life.lua",
    ["models.size"] = "models/size.lua",
    ["models.point"] = "models/point.lua",
    ["models.field"] = "models/field.lua",
  },
  copy_directories = {
    "doc",
  },
}
