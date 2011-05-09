import System.Environment   
import System.IO  
import Data.List 
import System.IO.Error

import qualified Jark.Vm as Vm
import qualified Jark.Cp as Cp
import qualified Jark.Ns as Ns
import qualified Jark.Doc as Doc
import qualified Jark.Repo as Repo
import qualified Jark.Package as Package

main = toTry `catch` handler  
              
toTry :: IO ()  

toTry = do
    args <- getArgs
    case length(args) of
      0 -> usage
      1 -> do let modCmd = head args ++ "-usage"
              let (Just action) = lookup modCmd dispatch
              action ["help"]
      _ -> do (mod:command:args) <- getArgs
              let modCmd = mod ++ "-" ++ command
              let (Just action) = lookup modCmd dispatch  
              action args 

handler :: IOError -> IO ()
handler e = usage

dispatch :: [(String, [String] -> IO ())]  
dispatch =  [ ("cp-list" , Cp.list)  
            , ("cp-add"  , Cp.add)
            , ("vm-start", Vm.start)
            , ("vm-stat" , Vm.stat)
            , ("ns-load" , Ns.load)  
            , ("vm-usage" , Vm.usage)    
            , ("cp-usage" , Cp.usage)    
            , ("ns-usage" , Ns.usage)                  
            , ("repo-usage" , Repo.usage)                  
            , ("package-usage" , Package.usage)                              
            , ("doc-usage", Doc.usage)                  
            ] 

usage = do
  pg <- getProgName 
  putStrLn $ "USAGE: " ++ pg ++ " MODULE COMMAND [ARGS]"
  putStrLn $ "vm       start stop stat uptime threads"
  putStrLn $ "cp       list add"
  putStrLn $ "ns       list find load run repl"
  putStrLn $ "package  install uninstall versions deps search installed latest"
  putStrLn $ "repo     list add remove"
  putStrLn $ "doc      search examples comments"
