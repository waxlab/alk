#!/usr/bin/env lua
--| It is an automation system for development and code publishing
--|
--| * clean      Remove compile and test stage artifacts
--| * help       Retrieve the list of documented items
---| * install    Install the rockspec for all Lua versions
---| * remove     Uninstall the rockspec for all Lua versions
---| * sparse     Run semantic parser for C
--| * test       Compile, and run tests

local command = {}
local sh = require 'etc.run.sh'
local config = require 'etc.run.config'
local luaVersions = {"5.1","5.2","5.3","5.4"}
local docdir  = "./test"
local testdir = "./test"

local luabin = {
  ["5.1"] = sh.whereis("lua%s","5.1","51"),
  ["5.2"] = sh.whereis("lua%s","5.2","52"),
  ["5.3"] = sh.whereis("lua%s","5.3","53"),
  ["5.4"] = sh.whereis("lua%s","5.4","54"),
}

local
function list_modules()
  local proc = io.popen('find ./src -name "*.lua" -or -name "*.c"','r')
  if not proc then return end
  local list = {}
  local line
  while true do
    line = proc:read()
    if not line then break end
    list[line:gsub('./src/',''):gsub('/[^/]+$',''):gsub('/','.')]=1
  end
  for k,_ in pairs(list) do print(k) end
end


function test_compile(luaver, module)
  local compile = false
  if (module) then
    for k,v in pairs(config.clib) do
      if v[1] == module then compile=true end
    end
  end
  if compile then
    print(("\n│ -- Compiling for Lua %s"):format(luaver))
    sh.exec("SINGLE_MODULE=%q LUA_VERSION=%q luarocks --tree ./tree --lua-version %s make %s",module, luaver, luaver, config.rockspec)
  end
end

function test_lua(luaver,module)
  local lbin  = luabin[luaver]
  --local lpath = ("./tree/share/lua/?.lua;/tree/share/lua/%s/?/init.lua"):format(luaver,luaver)
  local lpath = ("./src/?/ex.lua"):format(luaver,luaver)
  local cpath = ("./tree/lib/lua/%s/?.so" ):format(luaver)
  local cmd = ('find %q -name "*.lua" 2>/dev/null'):format(testdir)
  print(("│ -- Testing with Lua %s\n"):format(luaver))
    sh.exec(
      [[ TZ=UTC+0 %s -e 'package.path=%q package.cpath=%q' -l %q ]],
      lbin, lpath, cpath, module
    )
end

--
-- Public actions
-- Below functions are used as actions called directly from Ex:
-- ./run docklist

function command.clean()
  print("Cleaning project")
  sh.exec("rm -rf ./tree ./wax ./out ./lua ./luarocks ./lua_modules ./.luarocks")
  sh.exec("rm -rf ./lua ./luarocks ./lua_modules ./.luarocks")
  sh.exec("find ./src -name '*.o' -delete")
end


function command.help()
  cmd = ([[
    cat $(find %s -name '*.lua') \
    | grep '\--\$'|cut -d' ' -f2- 2> /dev/null | fzf
  ]]):format(docdir)
  os.execute(cmd)
end


function command.test()
  local module = arg[2]
  if not module then return list_modules() end
  for i,luaver in ipairs(luaVersions) do
    test_compile(luaver, module:gsub('$','.c'):gsub('^','alk.'))
    test_lua(luaver, module)
  end
end


function command.sparse()
  local cmd = table.concat {
    [[ for i in $(find src/capi -name "*c") ; do ]],
      [[echo sparsing "$i" ; ]],
      [[sparse -Wsparse-error ]],
        [[ -Wno-declaration-after-statement ]],
        [[ -Wsparse-all ]],
        [[ -I/usr/include/lua%s ]],
        [[ -I./src ]],
        [[ -I./src/ext ]],
        [[ -I./src/lib ]],
        [[ "$i" 2>&1 | ]],
          [[ grep -v "unknown attribute\|note: in included file" | ]],
          [[ tee /dev/stderr; ]],
    [[ done ]]
  }
  print("\nRunning sparse")
  for _,luaver in ipairs(luaVersions) do
    print (("\n╒═══╡ Lua %s"):format(luaver))
    sh.exec(cmd:format(luaver))
    print ("╰╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶╶")
  end
  print("\nSparsed OK! :)\n")
end


docker_run_cmd = [[docker run -ti --rm --mount=type=bind,source=%q,target=/devel %q %s]]

function command.install()
  local cmd = 'luarocks --lua-version %q make %q'
  for k,_ in pairs(luabin) do
    os.execute(cmd:format(k, config.rockspec))
  end
end

function command.remove()
  local cmd = 'luarocks --lua-version %q remove %q'
  for k,_ in pairs(luabin) do
    os.execute(cmd:format(k, config.rockspec))
  end
end

if command[arg[1]] then
  command[arg[1]]( (table.unpack or unpack)(arg,2) )
else
  local f = io.open(arg[0])
  repeat
    line = f:read()
    if line and line:find('^%-%-[|{}]%s?') == 1 then
        print(line:sub(5))
    end
  until not line
  f:close()
end
