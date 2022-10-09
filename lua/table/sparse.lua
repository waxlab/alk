--local keys = require 'capi.table.sparse'.example

-- Get keys only from first level
local list = {"a","b",nil,nil,"c","d"}
list[100] = "hi"

-- Sparse length
function slen(t)
  local length = 0
  for k,_ in pairs(t) do
    if type(k) == 'number' and k > length then length = k end
  end
  return length
end

function spairs(t)
  local length = slen(t)
  local iter = function(t,k)
    k = k+1
    if k <= length then
      return k, t[k]
    end
  end
  return iter, t, 0
end

for i,v in spairs(list) do print(i,v) end
