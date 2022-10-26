local ludata = require 'capi.userdata.basic'

local coord = ludata.create(1,2,3);

local x, y, z = coord:unpack()
assert(x == 1 and y == 2 and z == 3)


local x, y, z = coord:rotate():unpack()
assert(x == 2 and y == 3 and z == 1)

assert( type( ludata.create(1,2,3)) == "userdata" )
