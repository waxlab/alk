local returns = require 'capi.stack.returns'.example

-- To return the values of Lua the stack is changed
local res, before, after = returns();
assert(res == "hi", 0, 1)

res, before, after = returns("a");
assert(res == "hi" and before == 1 and after == 2)

-- An interesting test... are so many arguments allowed?
res, before, after = returns(1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,"a","b","c","d","e","f")
assert(res == "hi" and before == 26 and after == 27)


