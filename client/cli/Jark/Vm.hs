module Jark.Vm
( start
, stat
) where 

import System.Environment   
import System.IO  


start :: [String] -> IO ()
start [host, port] =  putStrLn $ "Starting Vm " ++ host ++ port

stat :: [String] -> IO ()
stat [stat] =  putStrLn $ "Showing vm stats"

usage = do
    pg <- getProgName 
    putStrLn $ pg ++ " vm start [--port -p (9000)] [--jvm_opts o]"
    putStrLn $ "\tStart a local Jark server. Takes optional JVM options as a \" delimited string."
    putStrLn $ "\tTakes optional JVM options as a \" delimited string."
    putStrLn $ pg ++ " vm stop"
    putStrLn $ "\tShuts down the current Jark server."
    putStrLn $ pg ++ " vm connect [--host -r (localhost)] [--port -p (9000)]"
    putStrLn $ "\tConnect to a remote JVM."
    putStrLn $ pg ++ " vm threads"
    putStrLn $ "\tPrint a list of JVM threads."
    putStrLn $ pg ++ " vm uptime"
    putStrLn $ "\tThe uptime of the current Jark server."
    putStrLn $ pg ++ " vm gc"
    putStrLn $ "\tRun garbage collection on the current Jark server."
