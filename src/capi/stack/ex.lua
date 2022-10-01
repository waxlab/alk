local stack = require "alk.capi.stack.c"

assert( stack.args("o") == 1 )
assert( stack.args("o",10) == 2)
assert( stack.args("o",nil,{"a",10,false}) == 3)


-- The edges of stack.
-- In a stack of one item, the first (1) and the last(-1) are the same.
-- In a stack of two items the first (1) is the (-2) and the second is the (-1)
do
  -- stack:
  -- | {} |  1  -1
  local last, first = stack.edges({})
  assert(first == last)

  -- stack:
  -- | a |  1  -2
  -- | b |  2  -1
  local a, b = {}, {}
  local last, first = stack.edges(a, b)
  assert( first == a and last == b )
end

-- To return the values of Lua the stack is changed
do
  local res, before, after = stack.returns();
  assert(res == "hi", 0, 1)

  res, before, after = stack.returns("a");
  assert(res == "hi" and before == 1 and after == 2)

  -- An interesting test... are so many arguments allowed?
  res, before, after = stack.returns(1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,"a","b","c","d","e","f")
  assert(res == "hi" and before == 26 and after == 27)
end


