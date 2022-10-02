![ALK](https://repository-images.githubusercontent.com/544033573/bbb40228-393c-4f5e-ad65-25094ea08674)

# ALK - A Lua Knowledge

ALK is a Lua package created only to let the programmer use as reference or
sandbox. It is intended to be used not as a project dependency, but a notebook
where you can test and document ways of doing things in Lua in a fast way, like
if it was a gist.

Fork it, learn Lua, play with it and feel. Feel free to help the project
following the [Contributing Guidelines](CONTRIBUTING.md).


## How to use

As ALK is in its very beginning, you can just clone this repository and
head to the src folder. Each folder is a Lua module containing a single lesson
or specific concern.

Each lesson on C Api, should have a Lua file containing its tests, named
"ex.lua" and a C file named "ex.c".

Each lesson directly on Lua should have a Lua file. The file should not
generate any user output. All the examples should be written as tests
using the builtin Lua function `assert`. This works to show exactly what
is expected from the example at the same time that someone can run it
and check for its validity, still changing and playing with the values.


## How to play with

1. Clone repo and enter the directory

    git clone https://github.com/waxlab/alk.git alk
    cd alk

2. Choose the target Lua version you want to play with

    luarocks init --lua-version 5.4

3. To list the lessons/tests run:

    ./run test

4. Pick one of the list and run:

    ./run test capi.stack

It is expected the code be compiled and returns no error. As you change
the code, as every test should be in an `assert()` call so any unexpected
result will be shown on console.


## Structure

All the relevant tests and lessos are under the `src` folder.
For a test `capi.stack` there are two modules, a Lua and a C one.

Lua module is `src/capi/stack/ex.lua` and C module is `src/capi/stack/ex.c`.
Observe that to disambiguate the `require()` call, the Lua
module is `capi.stack` while the C one is `capi.stack.c`

To add a Lua module just drop it with the `ex.lua` name under the
module directory.

To add a C module drop the C module with its Lua corresponding
tests under the directory and add it to `etc/config.lua`.

I think that this is the most complex part of the ALK using.

Hope you enjoy the road to the moon :)

