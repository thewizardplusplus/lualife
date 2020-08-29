local luaunit = require("luaunit")
local middleclass = require("middleclass")
local Stringifiable = require("lualife.models.stringifiable")

-- luacheck: globals TestStringifiable
TestStringifiable = {}

function TestStringifiable.test_tostring()
  local MockClass = middleclass("MockClass")
  MockClass:include(Stringifiable)
  MockClass.__data = function()
    return {
      number = 2.3,
      text = "test",
    }
  end

  local mock = MockClass:new()
  local text = tostring(mock)

  luaunit.assert_is_string(text)
  luaunit.assert_equals(text, '{number = 2.3,text = "test"}')
end
