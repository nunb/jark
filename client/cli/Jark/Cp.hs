module Jark.Cp
( list  
, add  
) where 

import System.Environment   
import System.IO  

add :: [String] -> IO ()
add [jarPath] =  putStrLn $ "Adding jarpath " ++ jarPath

list :: [String] -> IO ()
list [jarPath] =  putStrLn $ "Listing classpaths " ++ jarPath
