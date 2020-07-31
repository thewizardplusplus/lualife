local luaunit = require("luaunit")

for _, module in ipairs({
  "models.size",
  "models.point",
  "models.field",
  "life",
  "random",
}) do
  require("lualife." .. module .. "_test")
end

os.exit(luaunit.run())
