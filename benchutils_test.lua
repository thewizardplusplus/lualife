local luaunit = require("luaunit")
local luamark = require("luamark")
local assertions = require("luatypechecks.assertions")
local benchutils = require("lualife.benchutils")

local _RUN_OUTPUT = string.format(
  "\r%-50s time: %-25s memory: %-25s\n",
  "example",
  "time result",
  "memory result"
)

local function _set_timeit_mock(rounds)
  assertions.is_integer(rounds)

  luamark.timeit = function(operation, options)
    assertions.is_callable(operation)
    assertions.is_table(options)
    luaunit.assert_equals(options, { rounds = rounds })

    operation()

    return setmetatable({ median = 2.3 }, {
      __tostring = function()
        return "time result"
      end,
    })
  end
end

local function _set_memit_mock(rounds)
  assertions.is_integer(rounds)

  luamark.memit = function(operation, options)
    assertions.is_callable(operation)
    assertions.is_table(options)
    luaunit.assert_equals(options, { rounds = rounds })

    operation()

    return setmetatable({ median = 4.2 }, {
      __tostring = function()
        return "memory result"
      end,
    })
  end
end

-- luacheck: globals TestBenchutils
TestBenchutils = {}

function TestBenchutils:setUp()
  self.original_arg = arg
  self.original_getenv = os.getenv
  self.original_write = io.write
  self.original_getinfo = debug.getinfo
  self.original_timeit = luamark.timeit
  self.original_memit = luamark.memit

  self.environment = {}
  self.output = ""
  rawset(_G, "arg", {})
  rawset(os, "getenv", function(name)
    assertions.is_string(name)

    return self.environment[name]
  end)
  rawset(io, "write", function(text)
    assertions.is_string(text)

    self.output = self.output .. text
  end)
end

function TestBenchutils:tearDown()
  rawset(_G, "arg", self.original_arg)
  rawset(os, "getenv", self.original_getenv)
  rawset(io, "write", self.original_write)
  rawset(debug, "getinfo", self.original_getinfo)
  luamark.timeit = self.original_timeit
  luamark.memit = self.original_memit

  benchutils.reload_options()
end

function TestBenchutils:test_init_disabled()
  rawset(_G, "arg", {"test.lua", "--other"})

  local initialized = benchutils.init()

  luaunit.assert_false(initialized)
  luaunit.assert_equals(arg, {"test.lua", "--other"})
  luaunit.assert_equals(self.output, "")
end

function TestBenchutils:test_init_by_flag()
  rawset(_G, "arg", {"test.lua", "--bench", "--other"})

  local initialized = benchutils.init()

  luaunit.assert_true(initialized)
  luaunit.assert_equals(arg, {"test.lua", "--other"})
  self:_assert_init_output(5)
end

function TestBenchutils:test_init_by_environment()
  for _, value in ipairs({"true", "TRUE", "1"}) do
    rawset(_G, "arg", {"test.lua", "--other"})
    self.environment.BENCH = value
    self.output = ""

    local initialized = benchutils.init()

    luaunit.assert_true(initialized)
    luaunit.assert_equals(arg, {"test.lua", "--other"})
    self:_assert_init_output(5)
  end
end

function TestBenchutils:test_init_with_custom_rounds()
  rawset(_G, "arg", {"test.lua", "--other"})
  self.environment.BENCH = "TRUE"
  self.environment.BENCH_ROUNDS = "23"

  local initialized = benchutils.init()

  luaunit.assert_true(initialized)
  luaunit.assert_equals(arg, {"test.lua", "--other"})
  self:_assert_init_output(23)
end

function TestBenchutils:test_print_name()
  rawset(debug, "getinfo", function(level, options)
    assertions.is_integer(level)
    luaunit.assert_equals(level, 2)

    assertions.is_string(options)
    luaunit.assert_equals(options, "S")

    return { source = "@/tmp/example_bench.lua" }
  end)

  benchutils.print_name()

  luaunit.assert_equals(
    self.output,
    "\r" .. string.rep(" ", 50) .. "\n"
      .. "[[example_bench.lua]]\n"
      .. "---------------------\n"
  )
end

function TestBenchutils:test_run_with_default_rounds()
  self.environment.BENCH = "TRUE"
  _set_timeit_mock(5)
  _set_memit_mock(5)

  benchutils.init()
  self.output = ""

  local calls = 0
  benchutils.run("example", function()
    calls = calls + 1
    return calls
  end)

  luaunit.assert_equals(calls, 2)
  luaunit.assert_equals(self.output, _RUN_OUTPUT)
end

function TestBenchutils:test_run_with_custom_rounds()
  self.environment.BENCH = "TRUE"
  self.environment.BENCH_ROUNDS = "23"
  _set_timeit_mock(23)
  _set_memit_mock(23)

  benchutils.init()
  self.output = ""

  local calls = 0
  benchutils.run("example", function()
    calls = calls + 1
    return calls
  end)

  luaunit.assert_equals(calls, 2)
  luaunit.assert_equals(self.output, _RUN_OUTPUT)
end

function TestBenchutils:test_run_with_reloaded_rounds()
  self.environment.BENCH = "TRUE"
  self.environment.BENCH_ROUNDS = "23"
  _set_timeit_mock(42)
  _set_memit_mock(42)

  benchutils.init()
  self.output = ""

  self.environment.BENCH_ROUNDS = "42"
  benchutils.reload_options()

  local calls = 0
  benchutils.run("example", function()
    calls = calls + 1
    return calls
  end)

  luaunit.assert_equals(calls, 2)
  luaunit.assert_equals(self.output, _RUN_OUTPUT)
end

function TestBenchutils:test_run_with_long_name()
  self.environment.BENCH = "TRUE"
  _set_timeit_mock(5)
  _set_memit_mock(5)

  benchutils.init()
  self.output = ""

  local name = string.rep("x", 51)
  local calls = 0
  benchutils.run(name, function()
    calls = calls + 1
    return calls
  end)

  luaunit.assert_equals(calls, 2)
  luaunit.assert_equals(self.output, string.format(
    "\r%s\n%s time: %-25s memory: %-25s\n",
    name,
    string.rep(" ", 50),
    "time result",
    "memory result"
  ))
end

function TestBenchutils:_assert_init_output(rounds)
  assertions.is_integer(rounds)

  local message = string.format(
    "Benchmarks (%s, %s clock, %d rounds)",
    type(jit) == "table" and jit.version or _VERSION,
    luamark.clock_name,
    rounds
  )
  luaunit.assert_equals(
    self.output,
    "\n"
      .. message .. "\n"
      .. string.rep("=", #message) .. "\n"
  )
end
