local t = require 'alk.capi.table.c'

-- capi.table.values(t:{}) : {}
-- Works like table.unpack but for any kind of tables.
-- As table keys doesn't keep order, doesn't make much sense so.
do
  local a,b = t.values {x=100, y="hi"}
  print(a,b)
  assert(
    a == 100 and b == "hi"
    or
    a == "hi" and b == 100
  )
end


-- capi.table.keys(t:{}) : string, ...
-- Get keys only from first level
do
  local a, b = t.keys {x = "b", y = {z = 10}}
  -- The order may vary as tables are not sorted
  assert(a == "x" or a == "y")
  assert(b == "x" or b == "y")
end

-- capi.table.keysrec(t:{}) : string, ...
-- Get keys recursively
do
  local a, b, c, d = t.keysrec { w = { x = { y = { z = 10}}}}
  assert(a == "w" and b == "x" and c == "y" and d == "z")

  -- In this case we check in different orders
  local a, b, c, d = t.keysrec { w = { x=1 }, y = { z=1 }}
  assert(
    (a == "w" and b == "x" and c == "y" and d == "z")
    or
    (a == "y" and b == "z" and c == "w" and d == "x")
  )
end
