module Jark.Doc
( search
) where 

import System.Environment   
import System.IO  

search :: [String] -> IO ()
search [ns] = putStrLn $ "Searching doc " ++ ns
