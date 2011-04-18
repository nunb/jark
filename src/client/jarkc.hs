import System.Environment
 
-- | 'main' runs the main program
main :: IO ()
main = getArgs >>= print . message . head
 
message s = "The beginnings of a superfast jark client" ++ s
