local script_file = arg[0]
local script_path = script_file:match(".*/")

local luaunit = require(
	 script_path .. "vendor/luaunit/luaunit"
)

for _, module in ipairs({
  "size",
  "point",
  "field",
  "life",
}) do
  require(script_path .. module .. "_test")
end

os.exit(luaunit.run())
