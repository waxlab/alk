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
local luaVersions = {"5.1","5.2","5.3","5.4"}
local docdir  = "./test"
local testdir = "./test"

local luabin = {
  ["5.1"] = sh.whereis("lua%s","5.1","51"),
  ["5.2"] = sh.whereis("lua%s","5.2","52"),
  ["5.3"] = sh.whereis("lua%s","5.3","53"),
  ["5.4"] = sh.whereis("lua%s","5.4","54"),
}

local L = {}
if luaver == '5.1' then

  L.setfenv = setfenv

  function L.load(chunk, envt)
    local fn, err = loadstring(chunk, nil)
    if not fn then return fn, err end
    if envt then setfenv(fn, envt) end
    return fn
  end

  function L.loadfile(filename, envt)
    local fn, err = loadfile(filename)
    if err then return fn, err end
    if envt then return setfenv(fn, envt) end
    return fn
  end

else

  function L.setfenv(fn, envt)
    debug.upvaluejoin(fn, 1, function() return envt end, 1)
    return fn
  end

  function L.load(chunk, envt)
    return load(chunk, nil, 't', envt)
  end

  function L.loadfile(f, e)
    return loadfile(f, 't', e)
  end

end


local
function list_modules(pre)
  local proc = io.popen('cd ./src && find . -name "*.lua"','r')
  if not proc then return end
  local list = {}
  local line
  while true do
    line = proc:read()
    if not line then break end
    list[line:gsub('^%./',''):gsub('%.lua$',''):gsub('/','.')]=1
  end
  for k,_ in pairs(list) do print(k) end
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

function compile(config, cfile)
  local cmd_obj   = '@CC @CFLAGS -I @LUA_INCDIR -c @cfile -o @cpath.@OBJ_EXTENSION'
  local cmd_shobj = '@CC @LIBFLAG -o @cpath.@LIB_EXTENSION @cpath.@OBJ_EXTENSION'
  os.execute(('mkdir -p %q'):format(config.cpath))
  os.execute((cmd_obj):gsub('@([%w_]+)', function(p) return config[p] end))
  os.execute((cmd_shobj):gsub('@([%w_]+)', function(p) return config[p] end))
end


function command.test()
  local module = arg[2]
  if not module then return list_modules() end
  for i,luaver in ipairs(luaVersions) do
    local p = io.popen(([[luarocks --lua-version %q config]]):format(luaver))
    if p then
      local config = {}
      L.load(p:read('a*'),config)()
      if config then
        config.variables.lua_version = config.lua_version
        config.variables.lua_interpreter = config.lua_interpreter
        config = config.variables
        config.CFLAGS = '-Wall -Wextra -O2 -fPIC -fdiagnostics-color=always'
      end

      config.mpath = module:gsub('%.','/')
      config.cfile = ('./src/%s.c'):format(config.mpath)
      config.cpath = ('./.out/%s/%s'):format(config.lua_version,config.mpath)
      local exists = io.open(config.cfile)
      if exists then
        exists:close()
        compile(config)
      end
      local cpath = ('./.out/%s/?.%s;;'):format(
        config.lua_version,
        config.LIB_EXTENSION
      )
      local st, st1, st2 = os.execute(('LUA_CPATH=%q %s %q'):format(
        cpath,
        config.lua_interpreter,
        config.cfile:gsub('%.c$','.lua')
      ))
      if (st2 or st1 or st2) == 0 then
        print(('Lua %s OK'):format(config.lua_version))
      end
    end
  end
end


function command.sparse()
  local cmd = table.concat {
    [[ for i in $(find src -name "*c") ; do ]],
      [[echo sparsing "$i" ; ]],
      [[sparse -Wsparse-error ]],
        [[ -Wno-declaration-after-statement ]],
        [[ -Wsparse-all ]],
        [[ -I/usr/include/lua%s ]],
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
