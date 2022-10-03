local args = require 'capi.stack.args'

assert( args("o") == 1 )
assert( args("o",10) == 2 )
assert( args("o",nil, {"a",10,false} ) == 3)
