module Jark.Ns
( find
, load
) where 

import System.Environment   
import System.IO  

load :: [String] -> IO ()
load [ns] = putStrLn $ "Loading namespace " ++ ns

find :: [String] -> IO ()
find [ns] = putStrLn $ "Finding namespace " ++ ns
