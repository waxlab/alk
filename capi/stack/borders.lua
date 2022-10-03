-- In a stack of one item, the first (1) and the last(-1) are the same.
-- In a stack of two items the first (1) is the (-2) and the second is the (-1)


local borders = require 'capi.stack.borders'.example

-- stack:
-- {} = 1  -1
local last, first = borders({})
assert(first == last)

-- stack:
-- a =  1  -2
-- b =  2  -1
local a, b = {}, {}
local last, first = borders(a, b)
assert( first == a and last == b )
