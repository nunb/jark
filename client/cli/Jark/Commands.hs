module Jark.Commands
( dispatch
, cpList  
, cpAdd  
, nsLoad
, vmStart
, vmStat
) where 

import System.Environment   
import System.IO  


dispatch :: [(String, [String] -> IO ())]  
dispatch =  [ ("cp-list", cpList)  
            , ("cp-add",  cpAdd)
            , ("vm-start", vmStart)
            , ("vm-stat", vmStat)
            , ("ns-load", nsLoad)  
            ] 

vmStart :: [String] -> IO ()
vmStart [host, port] =  putStrLn $ "Starting Vm " ++ host ++ port

vmStat :: [String] -> IO ()
vmStat [stat] =  putStrLn $ "Showing vm stats"

cpAdd :: [String] -> IO ()
cpAdd [jarPath] =  putStrLn $ "Adding jarpath " ++ jarPath

cpList :: [String] -> IO ()
cpList [jarPath] =  putStrLn $ "Listing classpaths " ++ jarPath

nsLoad :: [String] -> IO ()
nsLoad [ns] = putStrLn $ "Loading namespace " ++ ns
