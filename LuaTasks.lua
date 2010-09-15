require "tlua"

local function docs()
  tlua.invoke("clean")
  os.execute("luadoc -d docs --nomodules tlua.lua")
end

local function clean()
  os.execute("rm -rf docs")
end

local function test()
  os.execute("shake test.lua")
end

tlua.task("docs", "Run Luadoc for the Tlua project", docs)
tlua.task("clean", "Clean up project directory", clean)
tlua.task("test", "Run tests", test)
