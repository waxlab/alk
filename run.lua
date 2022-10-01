#!/usr/bin/env lua
if arg[1] and arg[1]:match("5%.") then
  os.execute("luarocks --lua-version %q init"):format(arg[1])
else
  os.execute("./luarocks build")
  os.execute(
    ([[./lua -l %q]])
    :format(
      ([[alk.%s]])
        :format(arg[1])
    )
  )
end
