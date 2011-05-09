module Jark.Self
( untilM
, while2
, ifM  )
where 
  
untilM p x = x >>= (\y -> if p y then return y else untilM p x) 

-- repeats two actions until either returns true
while2 x y = ifM x (return ()) $ ifM y (return ()) $ while2 x y 

-- monadic `if`
ifM p t f  = p >>= (\p' -> if p' then t else f)
