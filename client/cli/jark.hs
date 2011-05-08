import System.Environment   
import System.IO  
import Data.List 
import Jark.Commands
  
main = do  
    (mod:command:args) <- getArgs
    let modCmd = mod ++ "-" ++ command
    let (Just action) = lookup modCmd dispatch  
    action args 
                      
