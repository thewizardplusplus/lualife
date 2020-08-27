local luaunit = require("luaunit")
local types = require("lualife.types")

-- luacheck: globals TestTypes
TestTypes = {}

function TestTypes.test_is_instance_false_not_table()
  local result = types.is_instance(nil)

  luaunit.assert_is_boolean(result)
  luaunit.assert_false(result)
end

function TestTypes.test_is_instance_false_missed_method()
  local result = types.is_instance({})

  luaunit.assert_is_boolean(result)
  luaunit.assert_false(result)
end

function TestTypes.test_is_instance_false_incorrect_method()
  local result = types.is_instance({isInstanceOf = 23})

  luaunit.assert_is_boolean(result)
  luaunit.assert_false(result)
end

function TestTypes.test_is_instance_false_by_check()
  local result = types.is_instance({
    isInstanceOf = function()
      return false
    end
  })

  luaunit.assert_is_boolean(result)
  luaunit.assert_false(result)
end

function TestTypes.test_is_instance_true()
  local result = types.is_instance({
    isInstanceOf = function()
      return true
    end
  })

  luaunit.assert_is_boolean(result)
  luaunit.assert_true(result)
end

function TestTypes.test_is_number_with_limits_false_not_number()
  local result = types.is_number_with_limits(nil)

  luaunit.assert_is_boolean(result)
  luaunit.assert_false(result)
end

function TestTypes.test_is_number_with_limits_false_minimum()
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
  local result = types.is_number_with_limits(-math.huge)

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
