module Jark.Doc
( search
, usage  
) where 

import System.Environment   
import System.IO  

search :: [String] -> IO ()
search [ns] = putStrLn $ "Searching doc " ++ ns

usage :: [String] -> IO ()
usage [help] = do
    pg <- getProgName 
    putStrLn $ pg ++ " doc search function"
    putStrLn $ "\tFind the docstring for function."
    putStrLn $ pg ++ " doc examples function [namespace]"
    putStrLn $ pg ++ " doc comments function [namespace]"
