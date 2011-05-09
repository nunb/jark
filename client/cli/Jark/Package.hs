module Jark.Package ( 
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
    putStrLn $ pg ++ " package install (--package -p PACKAGE) [--version -v]"
    putStrLn $ "\tInstall the relevant version of package from clojars."
    putStrLn $ pg ++ " package uninstall (--package -p PACKAGE)"
    putStrLn $ "\tUninstall the package."
    putStrLn $ pg ++ " package versions (--package -p PACKAGE)"
    putStrLn $ "\tList the versions of package installed."
    putStrLn $ pg ++ " package deps (--package -p PACKAGE) [--version -v]"
    putStrLn $ "\tPrint the library dependencies of package."
    putStrLn $ pg ++ " package search (--package -p PACKAGE)"
    putStrLn $ "\tSearch clojars for package."
    putStrLn $ pg ++ " package installed"
    putStrLn $ "\tList all packages installed."
    putStrLn $ pg ++ " package latest (--package -p PACKAGE)"
    putStrLn $ "\tPrint the latest version of the package."

replUsage :: String
replUsage = unlines 
            ["/package install (--package -p PACKAGE) [--version -v]",
             "/package uninstall (--package -p PACKAGE)",
             "/package versions (--package -p PACKAGE)",
             "/package deps (--package -p PACKAGE) [--version -v]",
             "/package search (--package -p PACKAGE)",
             "/package list",
             "/package latest (--package -p PACKAGE)"]
