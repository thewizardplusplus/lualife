---
-- @module benchutils

local luaunit = require("luaunit")
local luamark = require("luamark")
local assertions = require("luatypechecks.assertions")

local _MAX_NAME_WIDTH = 50

local _rounds
local _sink

local function _take_flag(flag)
  assertions.is_string(flag)

  for index = #arg, 1, -1 do
    if arg[index] == flag then
      table.remove(arg, index)
      return true
    end
  end

  return false
end

local function _underline(text, line_character)
  assertions.is_string(text)
  assertions.is_integer(line_character)

  local trimmed_text = (string.gsub(text, "%s+$", ""))
  return text .. "\n"
    .. string.rep(string.char(line_character), #trimmed_text)
end

local benchutils = {}

---
-- @treturn bool whether benchmarks should run
function benchutils.init()
  local bench_env = os.getenv("BENCH") or ""
  local is_bench_requested = _take_flag("--bench")
    or string.lower(bench_env) == "true"
    or bench_env == "1"
  if not is_bench_requested then
    return false
  end

  benchutils.reload_options()

  local runtime = type(jit) == "table" and jit.version or _VERSION
  local message = string.format(
    "Benchmarks (%s, %s clock, %d rounds)",
    runtime,
    luamark.clock_name,
    _rounds
  )
  io.write("\n" .. _underline(message, string.byte("=")) .. "\n")

  return true
end

---
-- @function reload_options
function benchutils.reload_options()
  _rounds = tonumber(os.getenv("BENCH_ROUNDS")) or 5
end

---
-- @function print_name
function benchutils.print_name()
  local source = debug.getinfo(2, "S").source
  source = source:match("^@(.+)$") or source

  local filename = source:match("([^/\\]+)$") or source

  local message = string.format("[[%s]]", filename)
  io.write(
    -- clear possible LuaUnit progress output (dots or "E" markers)
    "\r" .. string.rep(" ", _MAX_NAME_WIDTH) .. "\n"
    .. _underline(message, string.byte("-")) .. "\n"
  )
end

---
-- @tparam string name
-- @tparam func operation func(): any
function benchutils.run(name, operation)
  assertions.is_string(name)
  assertions.is_callable(operation)

  local function _consume_result()
    _sink = operation()
  end

  local time = luamark.timeit(_consume_result, { rounds = _rounds })
  local memory = luamark.memit(_consume_result, { rounds = _rounds })

  local name_column = #name <= _MAX_NAME_WIDTH
    -- clear possible LuaUnit progress output (dots or "E" markers)
    and name .. string.rep(" ", _MAX_NAME_WIDTH - #name)
    or name .. "\n" .. string.rep(" ", _MAX_NAME_WIDTH)
  io.write(string.format(
    "\r%s time: %-25s memory: %-25s\n",
    name_column,
    tostring(time),
    tostring(memory)
  ))

  luaunit.assert_not_nil(_sink)
  luaunit.assert_true(time.median >= 0)
  luaunit.assert_true(memory.median >= 0)
end

return benchutils
