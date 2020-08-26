local luaunit = require("luaunit")
local types = require("lualife.types")

-- luacheck: globals TestTypes
TestTypes = {}

function TestTypes.test_is_positive_false_not_number()
  local is_positive = types.is_positive(nil)

  luaunit.assert_is_boolean(is_positive)
  luaunit.assert_false(is_positive)
end

function TestTypes.test_is_positive_false_minimum_default()
  local is_positive = types.is_positive(-1)

  luaunit.assert_is_boolean(is_positive)
  luaunit.assert_false(is_positive)
end

function TestTypes.test_is_positive_false_minimum_not_default()
  local is_positive = types.is_positive(22, 23)

  luaunit.assert_is_boolean(is_positive)
  luaunit.assert_false(is_positive)
end

function TestTypes.test_is_positive_false_maximum()
  local is_positive = types.is_positive(43, 23, 42)

  luaunit.assert_is_boolean(is_positive)
  luaunit.assert_false(is_positive)
end

function TestTypes.test_is_positive_true_number()
  local is_positive = types.is_positive(23)

  luaunit.assert_is_boolean(is_positive)
  luaunit.assert_true(is_positive)
end

function TestTypes.test_is_positive_true_minimum_default()
  local is_positive = types.is_positive(0)

  luaunit.assert_is_boolean(is_positive)
  luaunit.assert_true(is_positive)
end

function TestTypes.test_is_positive_true_minimum_not_default()
  local is_positive = types.is_positive(23, 23)

  luaunit.assert_is_boolean(is_positive)
  luaunit.assert_true(is_positive)
end

function TestTypes.test_is_positive_true_maximum_default()
  local is_positive = types.is_positive(math.huge)

  luaunit.assert_is_boolean(is_positive)
  luaunit.assert_true(is_positive)
end

function TestTypes.test_is_positive_true_maximum_not_default()
  local is_positive = types.is_positive(42, 23, 42)

  luaunit.assert_is_boolean(is_positive)
  luaunit.assert_true(is_positive)
end
