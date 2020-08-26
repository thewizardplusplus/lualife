local luaunit = require("luaunit")
local types = require("lualife.types")

-- luacheck: globals TestTypes
TestTypes = {}

function TestTypes.test_is_number_with_limits_false_not_number()
  local result = types.is_number_with_limits(nil)

  luaunit.assert_is_boolean(result)
  luaunit.assert_false(result)
end

function TestTypes.test_is_number_with_limits_false_minimum_default()
  local result = types.is_number_with_limits(-1)

  luaunit.assert_is_boolean(result)
  luaunit.assert_false(result)
end

function TestTypes.test_is_number_with_limits_false_minimum_not_default()
  local result = types.is_number_with_limits(22, 23)

  luaunit.assert_is_boolean(result)
  luaunit.assert_false(result)
end

function TestTypes.test_is_number_with_limits_false_maximum()
  local result = types.is_number_with_limits(43, 23, 42)

  luaunit.assert_is_boolean(result)
  luaunit.assert_false(result)
end

function TestTypes.test_is_number_with_limits_true_number()
  local result = types.is_number_with_limits(23)

  luaunit.assert_is_boolean(result)
  luaunit.assert_true(result)
end

function TestTypes.test_is_number_with_limits_true_minimum_default()
  local result = types.is_number_with_limits(0)

  luaunit.assert_is_boolean(result)
  luaunit.assert_true(result)
end

function TestTypes.test_is_number_with_limits_true_minimum_not_default()
  local result = types.is_number_with_limits(23, 23)

  luaunit.assert_is_boolean(result)
  luaunit.assert_true(result)
end

function TestTypes.test_is_number_with_limits_true_maximum_default()
  local result = types.is_number_with_limits(math.huge)

  luaunit.assert_is_boolean(result)
  luaunit.assert_true(result)
end

function TestTypes.test_is_number_with_limits_true_maximum_not_default()
  local result = types.is_number_with_limits(42, 23, 42)

  luaunit.assert_is_boolean(result)
  luaunit.assert_true(result)
end
