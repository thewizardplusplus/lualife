local luaunit = require("luaunit")
local types = require("lualife.types")

-- luacheck: globals TestTypes
TestTypes = {}

function TestTypes.test_to_boolean_false()
  local result = types.to_boolean(false)

  luaunit.assert_is_boolean(result)
  luaunit.assert_false(result)
end

function TestTypes.test_to_boolean_false_analog()
  local result = types.to_boolean(nil)

  luaunit.assert_is_boolean(result)
  luaunit.assert_false(result)
end

function TestTypes.test_to_boolean_true()
  local result = types.to_boolean(true)

  luaunit.assert_is_boolean(result)
  luaunit.assert_true(result)
end

function TestTypes.test_to_boolean_true_analog()
  local result = types.to_boolean(23)

  luaunit.assert_is_boolean(result)
  luaunit.assert_true(result)
end
