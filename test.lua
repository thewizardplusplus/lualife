local luaunit = require("luaunit")

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

os.exit(luaunit.run())
