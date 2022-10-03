local values = require 'capi.table.values'.example

-- capi.table.values(t:{}) : {}
-- Works like table.unpack but for any kind of tables.
-- As table keys doesn't keep order, doesn't make much sense so.
do
  local a,b = values {x=100, y="hi"}
  assert(
    a == 100 and b == "hi"
    or
    a == "hi" and b == 100
  )
end



