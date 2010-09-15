local tablex = require "pl.tablex"

module("tlua.tasks", package.seeall)

local function print_tasks(descs)
  local keys = tablex.keys(descs)
  table.sort(keys)
  local longest = 0
  tablex.foreach(keys, function(v)
    local len = v:len()
    if len > longest then longest = len end
  end)
  local format = "%-" .. longest + 4 .. "s%s"
  for _, name in ipairs(keys) do
    print(string.format(format, name, descs[name]))
  end
end

local function list()
  print("System tasks:")
  print("-------------")
  print_tasks(tlua.system_descriptions)
  print("")
  print("User tasks:")
  print("-----------")
  print_tasks(tlua.descriptions)
end

local function help()
  print(string.format("tlua version %s, copyright %s, %s", tlua._version, tlua._author, tlua._year))
  print("Released under the MIT License\n")
  print [[
Tlua is a command-line Lua task runner. The following system-level
tasks are available:
  ]]
  print_tasks(tlua.system_descriptions)
end

tlua.system_task("list", "List all tasks", list)
tlua.system_task("help", "Show this message", help)