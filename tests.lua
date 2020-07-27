local luaunit = require("luaunit")

for _, module in ipairs({
  "size",
  "point",
  "field",
  "life",
}) do
  require("lualife." .. module .. "_test")
end

os.exit(luaunit.run())
