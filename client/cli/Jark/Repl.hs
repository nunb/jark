module Jark.Repl
( repl )
where 

import System.Console.Shell
import System.Console.Shell.ShellMonad
import System.Console.Shell.Backend.Readline
import qualified Jark.Vm as Vm
import qualified Jark.Cp as Cp
import qualified Jark.Ns as Ns
import qualified Jark.Package as Package
import qualified Jark.Doc as Doc
import qualified Jark.Repo as Repo
import qualified Jark.Nrepl as Nrepl
import Control.Monad
import Control.Monad.Error

defaultBackend = readlineBackend

repl :: IO ()
repl = do
  let 
    desc = 
      (mkShellDescription commands eval)
      { greetingText       = Nothing
      , prompt             = \_ -> return ("user" ++ ">> ")
      , commandStyle       = CharPrefixCommands '/'                             
      , secondaryPrompt    = Just $ \_ -> return "] "
      }
  runShell desc defaultBackend ()
    
eval :: String -> Sh () ()
eval x =  do s <- liftIO $ Nrepl.eval x
             shellPutStrLn s

-- eval :: String -> Sh () ()
-- eval x = shellPutStrLn x

commands =
  [ exitCommand "quit"
  , helpCommand "help"
  , cmd "version"   (shellPutInfo versionInfo) "Show jark version"
  , cmd "vm"        (shellPutInfo Vm.replUsage) "stop stat uptime threads gc"
  , cmd "cp"        (shellPutInfo Cp.replUsage) "list add"
  , cmd "ns"        (shellPutInfo Ns.replUsage) "list find load run"
  , cmd "package"   (shellPutInfo Package.replUsage) "install uninstall versions deps search installed latest"
  , cmd "doc"       (shellPutInfo Doc.replUsage) "search examples comments"
  , cmd "repo"      (shellPutInfo Repo.replUsage) "list add remove"
  ]

versionInfo :: String
versionInfo = unlines ["The jark clojure REPL, version "++ "0.4"]
