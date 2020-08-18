local luaunit = require("luaunit")

for _, module in ipairs({
  "random",
  "sets",
  "matrix" ,
  "life",
  "models.size",
  "models.point",
  "models.field",
  "models.placedfield",
}) do
  require("lualife." .. module .. "_test")
end

os.exit(luaunit.run())
