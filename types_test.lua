local luaunit = require("luaunit")
local types = require("lualife.types")
local MockClass = require("lualife.models.mockclass")

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

function TestTypes.test_is_callable_false_missed_metatable()
  local result = types.is_callable({})

  luaunit.assert_is_boolean(result)
  luaunit.assert_false(result)
end

function TestTypes.test_is_callable_false_missed_metamethod()
  local value = {}
  setmetatable(value, {})

  local result = types.is_callable(value)

  luaunit.assert_is_boolean(result)
  luaunit.assert_false(result)
end

function TestTypes.test_is_callable_false_incorrect_metamethod()
  local value = {}
  setmetatable(value, {__call = 23})

  local result = types.is_callable(value)

  luaunit.assert_is_boolean(result)
  luaunit.assert_false(result)
end

function TestTypes.test_is_callable_true_function()
  local value = function()
  end

  local result = types.is_callable(value)

  luaunit.assert_is_boolean(result)
  luaunit.assert_true(result)
end

function TestTypes.test_is_callable_true_metatable()
  local value = {}
  setmetatable(value, {
    __call = function()
    end,
  })

  local result = types.is_callable(value)

  luaunit.assert_is_boolean(result)
  luaunit.assert_true(result)
end

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
    end,
  })

  luaunit.assert_is_boolean(result)
  luaunit.assert_false(result)
end

function TestTypes.test_is_instance_true_by_check()
  local result = types.is_instance({
    isInstanceOf = function()
      return true
    end,
  })

  luaunit.assert_is_boolean(result)
  luaunit.assert_true(result)
end

function TestTypes.test_is_instance_true_real_class()
  local mock = MockClass:new(2.3, "test")
  local result = types.is_instance(mock, MockClass)

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
