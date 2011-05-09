module Jark.Repo ( 
  start
, stat
, usage
, replUsage
) where 

import System.Environment   
import System.IO  


start :: [String] -> IO ()
start [host, port] =  putStrLn $ "Starting Vm " ++ host ++ port

stat :: [String] -> IO ()
stat [stat] =  putStrLn $ "Showing vm stats"

usage :: IO ()
usage = do
    pg <- getProgName 
    putStrLn $ pg ++ " repo list"
    putStrLn $ "\tList current repositories."
    putStrLn $ pg ++ " repo add URL"
    putStrLn $ "\tAdd repository."
    putStrLn $ pg ++ " remove URL"
    putStrLn $ "\tRemove repository"

replUsage :: String
replUsage = unlines 
            ["/repo list",
             "/repo add URL",
             "/repo remove URL"]
