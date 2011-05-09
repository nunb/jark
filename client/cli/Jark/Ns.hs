module Jark.Ns ( 
  find
, load
, usage
, replUsage
) where 

import System.Environment   
import System.IO  

load :: [String] -> IO ()
load [ns] = putStrLn $ "Loading namespace " ++ ns

find :: [String] -> IO ()
find [ns] = putStrLn $ "Finding namespace " ++ ns

usage :: [String] -> IO ()
usage [help] = do
    pg <- getProgName 
    putStrLn $ pg ++ " ns list (prefix)?"
    putStrLn $ "\tList all namespaces in the classpath. Optionally takes a namespace prefix."
    putStrLn $ pg ++ " ns find prefix"
    putStrLn $ "\tFind all namespaces starting with the given name"
    putStrLn $ pg ++ " ns load file"
    putStrLn $ "\tLoads the given clj file, and adds relative classpath"
    putStrLn $ pg ++ " ns run main-ns args*"
    putStrLn $ "\tRuns the given main function with args."
    putStrLn $ pg ++ " ns repl namespace"
    putStrLn $ "\tLaunch a repl at given ns."

replUsage :: String
replUsage = unlines 
            ["/ns list (prefix)?",
             "/ns load file",
             "/ns run main-ns [args]"]
