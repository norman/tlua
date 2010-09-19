local tablex = require "pl.tablex"
local path   = require 'pl.path'

--- Tlua is a simple task runner for Lua.
module("tlua", package.seeall)

_author             = "Norman Clarke"
_year               = "2010"
_version            = "0.1.0"

default_file_name   = "LuaTasks.lua"
default_tasks_dir   = ".tlua"
default_task        = "help"
descriptions        = {}
system_descriptions = {}
local system_tasks  = {}
local tasks         = {}
local invocations   = {}

-- Get the task by name.
local function get_task(name)
  return system_tasks[name] or tasks[name]
end

-- Get a list of files in the default tasks dir.
local function home_files()
  local files = {}
  local my_dir = path.join(path.expanduser("~"), tlua.default_tasks_dir)
  if path.isdir(my_dir) then
    for root, _, entries in dir.walk(my_dir) do
      for _, entry in ipairs(dir.filter(entries, "*.lua")) do
        table.insert(files, path.join(root, entry))
      end
    end
  end
  return files
end

-- Get a list of all tasks files to load.
local function task_files()
  local local_file = path.join(path.abspath("."), tlua.default_file_name)
  local files = home_files()
  table.insert(files, local_file)
  return files
end

-- Load an individual task file.
local function load_file(file_path)
  local func, errors = loadfile(file_path)
  if not func then error(errors) end
  func()
end

--- Loads all task files from the current directory, and the default_tasks_dir.
-- This function is used by the tlua runner, there's proabably no reason for
-- you to ever invoke it in your own code.
function load_files()
  tablex.map(function(file)
    if path.exists(file) then
      load_file(file)
    end
  end, task_files())
end

--- Parse command line parameters.
-- Tlua eschews the complexity of something like getopt in favor of
-- a more limited, but flexible parameters format. Any colon-separated
-- arguments will be added to the params table as a key-value pair, while
-- anything else will simple be inserted into the table. So, for example,
-- the following Tlua command would result in the following parameters table:
-- <p><pre>tlua say hello to:John</pre></p>
-- <p><pre>{[1] = "say", ["to"] = "John"}</pre></p>
-- If you need a literal colon, you can escape it with a "\". At the moment, you
-- can only have one, though, because I'm using a very naive parsing. This will be
-- replaced with something less idiotic very soon.
-- @param t An optional arg table. If omitted, the global arg table will be used.
-- @return table
function get_params(t)
  t = t or arg
  local params = {}
  for i, v in ipairs(t) do
    if i ~= 1 then
      local key, pre, value = (v):match("(.*)(.):(.*)")
      if pre == "\\" then
        table.insert(params, (v:gsub("\\", "")))
      elseif key then
        params[key .. pre] = value or true
      else
        table.insert(params, v)
      end
    end
  end
  return params
end

--- Invokes a Tlua task.
-- @param name The task to invoke
-- @param only_once If true, only invoke the task once
function invoke(name, only_once)
  if not get_task(name) then
    error(('No such task "%s"'):format(tostring(name)))
  else
    if only_once and tablex.search(invocations, name) then
      return
    else
      table.insert(invocations, name)
      return get_task(name)()
    end
  end
end

--- Add a tlua task. This is intended to be used inside a task file.
-- @param name The task name. You are encouraged to use period-separated namespaces,
--             but you can use any format you desire.
-- @param description A description of the task.
-- @param func The task function itself.
function task(name, description, func)
  tasks[name]        = func
  descriptions[name] = description
end

--- Add a tlua system task. You are free to expand tlua as you see fit, or override
-- the default system tasks to do whatever you want. If you come up with anything
-- good, your patches are more than welcome. :-)
-- @param name The task name. System tasks should generally avoid any namespacing.
-- @param description A description of the task.
-- @param func The task function itself.
function system_task(name, description, func)
  system_tasks[name]        = func
  system_descriptions[name] = description
end
