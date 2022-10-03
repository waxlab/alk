![ALK](https://repository-images.githubusercontent.com/544033573/bbb40228-393c-4f5e-ad65-25094ea08674)

# ALK - A Lua Knowledge

ALK is a Lua project created be used by programmers as reference or playground.
It is intended to be used not as a project dependency, but a notebook where you
can test and document ways of doing things in Lua in a fast way, like if it was
a gist.

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

2. To list the lessons/tests run:

    ./run test

3. Pick one of the list and run:

    ./run test capi.stack.args


All these tests are inside a Lua file. In case of C tests and lessons, the
C file should have the same name as the Lua file (except by the extension).


## Structure

All the relevant tests and lessos are under the `src` folder.
For a test `capi.stack.borders` there are two files:
* `src/capi/stack/borders.lua` containing the tests
* `src/capi/stack/borders.c` containing the Lua C Api examples and that is
recompiled every time you issue `./run test capi.stack.borders`

Enjoy the Lua coding :)

