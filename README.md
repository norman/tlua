# Tlua

Tlua is a simple task runner for Lua that simplifies running and reusing small
bits of useful code. It lets you very easily build a command-line application
for dong things like running scripts in a project.

It is in some ways conceptually similar to [Rake](http://rake.rubyforge.org/),
but is oriented exclusively towards task running rather than project building,
and doesn't require a special file format or DSL.

## A Sample

Tlua looks for collections of tasks in a file named `LuaTasks.lua` in your
current directory, and also in a directory named `.tlua` in your home directory.
The files in `~/.tlua` can be in any heirachy and have any name, as long as they
have the extension `.lua`.

Here's an example `LuaTasks.lua` file:

    --- A "hello world" function for tlua.
    -- Looks for a greeting in params[1], or defaults to "hello".
    -- Looks for a person in params.to, or defaults to "world".
    -- Example: tlua say olá to:João
    local function sample_func()
      local params   = tlua.get_params()
      local greeting = params[1] or "hello"
      local who      = params.to or "world"
      print(string.format("%s %s!", greeting, who))
    end

    tlua.task("say", "Say a greeting", sample_func)

You can then invoke this task on the command line:

    $ tlua say hello to:John
    hello John!

Any function can be used as a task, as long as it does not require arguments. If
you want to make a function that requires arguments a task, you can simple wrap
it in a Tlua task that parses the parameters in the apropriate way:

    local function test_match()
      local params = tlua.get_params()
      print(string.match(params[1], params[2]))
    end

    tlua.task("string.match", "Print the result of string.match", test_match)

Then, invoke the example:

    $ tlua string.match 'joe@example.com' '.*@(.*)'
    example.com

## Installation

Install via Luarocks, or download and copy to the location you desire. At the
moment, the best way to install via Luarocks is:

    luarocks build http://github.com/norman/tlua/raw/master/tlua-scm1.rockspec

## Author

Norman Clarke - norman@njclarke.com

## License

Copyright (c) 2010 Norman Clarke

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.