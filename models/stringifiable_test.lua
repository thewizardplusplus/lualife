local luaunit = require("luaunit")
local MockClass = require("lualife.models.mockclass")

-- luacheck: globals TestStringifiable
TestStringifiable = {}

function TestStringifiable.test_tostring()
  local mock = MockClass:new(2.3, "test")
  local text = tostring(mock)

  luaunit.assert_is_string(text)
  luaunit.assert_equals(text, '{number = 2.3,text = "test"}')
end
