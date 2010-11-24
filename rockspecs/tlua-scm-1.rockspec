package = "tlua"
version = "scm-1"

source = {
  url = "git://github.com/norman/tlua.git",
}

description = {
  summary = "A simple task runner",
  detailed = [[
    Tlua helps reuse and run snippets of code from the command line.
  ]],
  license = "MIT/X11",
  homepage = "http://github.com/norman/tlua"
}

dependencies = {
  "lua >= 5.1",
  "penlight >= 0.8"
}

build = {
  type = "none",
  install = {
    lua = {
      "tlua.lua",
      ["tlua.tasks"] = "tlua/tasks.lua"
    },
    bin = {
      ["tlua"] = "bin/tlua"
    }
  }
}
