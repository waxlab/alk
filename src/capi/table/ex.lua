local t = require 'alk.capi.table.c'


do
  local a, b = t.keys {x = "b", y = 10}
  -- The order may vary as tables are not sorted
  assert(a == "x" or a == "y")
  assert(b == "x" or b == "y")
end

do
  local a, b, c, d = t.krecursive { w = { x = { y = { z = 10}}}}
  assert(a == "w" and b == "x" and c == "y" and d == "z")
end

do
  local a, b, c, d = t.krecursive { w = { x = 1}, y = { z=1 }}
  assert(
    (a == "w" and b == "x" and c == "y" and d == "z")
    or
    (a == "y" and b == "z" and c == "w" and d == "x")
  )
end
