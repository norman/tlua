require "tlua"
require "pl"

do
  print("Should add a task")
  tlua.task("hello", "returns 'hello'", function() return "hello" end)
  assert("hello", tlua.invoke("hello"))
end

do
  print("Should add a system task")
  tlua.system_task("hello", "returns 'hello'", function() return "hello" end)
  assert("hello", tlua.invoke("hello"))
end

do
  print("System tasks should have priority over user tasks")
  tlua.system_task("hello", "returns 'hello'", function() return "hello" end)
  tlua.task("hello", "returns 'hello'", function() return "goodbye" end)
  assert("hello", tlua.invoke("hello"))
end

do
  print("Should parse indexed params")
  local args = {"command", "a", "b"}
  local params = tlua.get_params(args)
  assert("a" == params[1])
  assert("b" == params[2])
end

do
  print("Should parse named params")
  local args = {"command", "a:b"}
  local params = tlua.get_params(args)
  assert("b" == params["a"])
end

do
  print("Should escape colons with a backslash")
  local args = {"command", "a\\:b"}
  local params = tlua.get_params(args)
  assert("a:b" == params[1])
end

do
  print("Should escape multiple colons with a backslash")
  local args = {"command", "a\\:b\\:c"}
  local params = tlua.get_params(args)
  assert("a:b:c" == params[1])
end