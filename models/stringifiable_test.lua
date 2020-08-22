local luaunit = require("luaunit")
local middleclass = require("middleclass")
local Stringifiable = require("lualife.models.stringifiable")

-- @class MockClass
-- @tfield number number
-- @tfield string text
local MockClass = middleclass("MockClass")
MockClass:include(Stringifiable)

-- @function MockClass:new
-- @tparam number number
-- @tparam string text
-- @treturn MockClass
function MockClass:initialize(number, text)
  assert(type(number) == "number")
  assert(type(text) == "string")

  self.number = number
  self.text = text
end

-- @function MockClass:__data
-- @treturn tab table with instance fields
function MockClass:__data()
  return {
    number = self.number,
    text = self.text,
  }
end

-- luacheck: globals TestStringifiable
TestStringifiable = {}

function TestStringifiable.test_tostring()
  local mock = MockClass:new(2.3, "test")
  local text = tostring(mock)

  luaunit.assert_is_string(text)
  luaunit.assert_equals(text, '{number = 2.3,text = "test"}')
end
