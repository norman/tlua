require "tlua"

local version = "1.0.0"
local archive  = "tlua-" .. version
local sh      = os.execute

local function docs()
  tlua.invoke("clean")
  sh("luadoc -d docs --nomodules tlua.lua")
end

local function clean()
  sh("rm -rf *.tar.gz docs " .. archive)
end

local function test()
  sh("shake test.lua")
end

local function rock()
  tlua.invoke("clean")
  sh("mkdir " .. archive)
  sh("cp -rp bin tlua tlua.lua " .. archive)
  sh(string.format("tar czf %s.tar.gz %s",  archive, archive))
end

tlua.task("docs", "Run Luadoc for the Tlua project", docs)
tlua.task("clean", "Clean up project directory", clean)
tlua.task("test", "Run tests", test)
tlua.task("rock", "Make dir for rock", rock)
