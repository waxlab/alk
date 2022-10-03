local keys = require 'capi.table.keys'.example

-- Get keys only from first level
local a, b = keys {x = "b", y = {z = 10}}

-- The order may vary as tables are not sorted
assert(a == "x" or a == "y")
assert(b == "x" or b == "y")
