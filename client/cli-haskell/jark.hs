import System.Environment   
import System.IO  
import Data.List 
import System.IO.Error
import System.Exit

-- Fixme: there is probably a concise way to import a directory containg modules
import qualified Jark.Vm as Vm
import qualified Jark.Cp as Cp
import qualified Jark.Ns as Ns
import qualified Jark.Doc as Doc
import qualified Jark.Repo as Repo
import qualified Jark.Repl as Repl
import qualified Jark.Package as Package
import qualified Jark.Self as Self

main = toTry `catch` handler  
              
toTry :: IO ()  

toTry = do
    args <- getArgs
    case length(args) of
      0 -> usage
      1 -> do let modCmd = head args ++ "-usage"
              case lookup modCmd dispatchThunk of
                (Just action) -> action
                Nothing       -> do putStrLn $ "`" ++ head args ++ "`" ++ " is not a valid module."
                                    usage
                              
      _ -> do (mod:command:rest) <- getArgs
              let modCmd = mod ++ "-" ++ command
              case length(rest) of    
                0 -> do let (Just action) = lookup modCmd dispatchThunk
                        action
                        exitWith ExitSuccess
                _ -> do let (Just action) = lookup modCmd dispatchArgs
                        action rest 
                        exitWith ExitSuccess
                     
handler :: IOError -> IO ()
handler e = usage

-- FIXME: This has to be dynamically generated
dispatchArgs :: [(String, [String] -> IO ())]  
dispatchArgs =  [ ("cp-add"  , Cp.add)
                , ("vm-start", Vm.start)
                , ("ns-load" , Ns.load)]            
            
dispatchThunk :: [(String, IO ())]             
dispatchThunk =  [ ("cp-list" , Cp.list)
                 , ("vm-usage" , Vm.usage)    
                 , ("cp-usage" , Cp.usage)    
                 , ("ns-usage" , Ns.usage)                  
                 , ("repo-usage" , Repo.usage)                  
                 , ("package-usage" , Package.usage)                              
                 , ("doc-usage", Doc.usage)                  
                 , ("vm-stat" , Vm.stat)              
                 , ("repl-usage", Repl.repl)    
                 , ("self-install", Self.install)]
            
-- FIXME: the usage list has to be dynamically generated            
usage = do
  pg <- getProgName 
  putStrLn $ "USAGE: " ++ pg ++ " MODULE COMMAND [ARGS]"
  putStrLn $ "cp       list add"
  putStrLn $ "doc      search examples comments"
  putStrLn $ "ns       list find load run repl"
  putStrLn $ "package  install uninstall versions deps search installed latest"
  putStrLn $ "repo     list add remove"
  putStrLn $ "vm       start stop stat uptime threads"
