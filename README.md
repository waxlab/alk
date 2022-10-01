# ALK - A Lua Knowledge

The main purpose of this project is gather Lua examples in a comprehensible
way generating manuals, output in most diversified formats from the simple
Lua and C code.

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

3. Then you just need to pick the folder name under the `./src`
and run it:

    ./lua ./run.lua stack

It is expected the code be compiled and returns no error. As you change
the code, as every test should be in an `assert()` call any error
will be shown on console.
