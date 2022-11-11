![ALK](https://repository-images.githubusercontent.com/544033573/bbb40228-393c-4f5e-ad65-25094ea08674)

# ALK - A Lua Knowledge


ALK is a group of snippets and articles to serve as reference on Lua and Lua C API development. It can be read or forked, so you can play with code and make your own discoveries.

Fork it, learn Lua, play with it and feel free to help this project.

## Quickstart

1. Clone repo and enter the directory

    git clone https://github.com/waxlab/alk.git alk
    cd alk

2. To list the lessons/tests run:

    ./run test

3. Pick one of the list and run:

    ./run test capi.stack.args

All the relevant tests and lessons are under the `src` folder.
For a test `capi.stack.borders` there are two files:
* `src/capi/stack/borders.lua` containing the tests
* `src/capi/stack/borders.c` containing the Lua C Api examples and that is
recompiled every time you issue `./run test capi.stack.borders`


## Index

* [Contributing](contributing.md)

### Lua

* [Sparse Tables](lua/table/sparse.lua)

### C Api

* Stack
  - Returns [C](capi/stack/returns.c) / [Lua](capi/stack/returns.lua)
  - Borders [C](capi/stack/borders.c) / [Lua](capi/stack/borders.lua)
  - Arguments [C](capi/stack/args.c) / [Lua](capi/stack/args.lua)

* Table
  - Keys [C](capi/table/keys.c) / [Lua](capi/table/keys.lua)
  - Recursive Keys [C](capi/table/recurkeys.c) / [Lua](capi/table/recurkeys.lua)
  - Values [C](capi/table/values.c) / [Lua](capi/table/values.lua)

* Userdata
  - Basic [C](capi/userdata/basic.c) / [Lua](capi/userdata/basic.lua)

### More Articles

* [C memory handling: Good practices](more/c-memory.md)


Enjoy the Lua coding :)

