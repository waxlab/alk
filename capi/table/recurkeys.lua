-- Example of behavior unpacking the table keys recursively


-- capi.table.keysrecurkeys.example(t:{}) : string, ...
local recurkeys = require 'capi.table.recurkeys'.example


-- As they are nested and there is a single parent for each inner,
-- the keys have always the same order
local a, b, c, d = recurkeys { w = { x = { y = { z = 10}}}}
assert(a == "w" and b == "x" and c == "y" and d == "z")


-- Due to the Lua table natures, here you can see the same effect
-- of the `pairs()` functions. It can get the keys but the order
-- can vary.
local a, b, c, d = recurkeys { w = { x=1 }, y = { z=1 }}
assert(
  (a == "w" and b == "x" and c == "y" and d == "z")
  or
  (a == "y" and b == "z" and c == "w" and d == "x")
)
