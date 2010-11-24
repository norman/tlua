package = "tlua"
version = "1.0.0-0"

source = {
  url = "http://cloud.github.com/downloads/norman/tlua/tlua-1.0.0.tar.gz",
  md5 = "b3f6e3a3a0759193e3db26dc78efd917"
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
