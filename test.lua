local luaunit = require("luaunit")
local benchutils = require("lualife.benchutils")

for _, module in ipairs({
  "benchutils",
  "benchlocalutils",
  "random",
  "sets",
  "matrix" ,
  "life",
  "models.field",
  "models.placedfield",
}) do
  require("lualife." .. module .. "_test")
end

if benchutils.init() then
  for _, module in ipairs({
    "random",
    "sets",
    "matrix" ,
    "life",
    "models.field",
    "models.placedfield",
  }) do
    require("lualife." .. module .. "_bench")
  end
end

os.exit(luaunit.run())
