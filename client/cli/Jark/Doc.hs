module Jark.Doc ( 
  search
, usage  
, replUsage
) where 

import System.Environment   
import System.IO  

search :: [String] -> IO ()
search [ns] = putStrLn $ "Searching doc " ++ ns

usage :: IO ()
usage = do
    pg <- getProgName 
    putStrLn $ pg ++ " doc search function"
    putStrLn $ "\tFind the docstring for function."
    putStrLn $ pg ++ " doc examples function [namespace]"
    putStrLn $ pg ++ " doc comments function [namespace]"

replUsage :: String
replUsage = unlines 
            ["/doc search function",
             "/doc examples function [namespace]",
             "/doc comments function [namespace]"]
