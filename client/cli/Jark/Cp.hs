module Jark.Cp ( 
  list  
, add  
, usage
, replUsage
) where 

import System.Environment   
import System.IO  

add :: [String] -> IO ()
add [jarPath] =  putStrLn $ "Adding jarpath " ++ jarPath

list :: [String] -> IO ()
list [jarPath] =  putStrLn $ "Listing classpaths " ++ jarPath

usage :: [String] -> IO ()
usage [help] = do
    pg <- getProgName 
    putStrLn $ pg ++ " cp list"
    putStrLn $ "\tList the classpath for the current Jark server."
    putStrLn $ pg ++ " cp add args+"
    putStrLn $ "\tAdd to the classpath for the current Jark server."
    putStrLn $ pg ++ " cp run main-class"
    putStrLn $ "\tRun main-class on the current Jark server."

replUsage :: String
replUsage = unlines 
            ["/cp list",
             "/cp add [PATH(s)]"]
