-- This is equivalent to the Haskell foldl:
-- foldl :: (b -> a -> b) -> b -> [a] -> b
-- foldl f z []     = z
-- foldl f z (x:xs) = foldl f (f z x) xs



local foldl
function foldl(f, z, xs, i)
  if (i or 0) >= #xs then return z end
  i = (i or 0) + 1
  return foldl(f, f(z, xs[i]), xs, i)
end

local sum
function sum(a, b) return a + b end

print( assert( foldl(sum,0,{1,2,3,5,8,13,21,34,55,89}) == 231 ) )
