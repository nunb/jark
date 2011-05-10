module Jark.Nrepl
( eval )
where 
  
import Network
import System.IO
import Data.Char(toUpper)

port = 9000
ip   = "localhost"

eval :: String -> IO String
eval expr = do
  putStrLn expr
  return expr
      
evalExpr :: String -> IO String
evalExpr expr = withSocketsDo $ do
                hdl <- connectTo "localhost" (PortNumber 9000)
                hSetBuffering hdl NoBuffering          
                hPutStr hdl "test message"
                res <- hGetContents hdl
                mapM_ (\x -> putStr (show x) >> hFlush stdout) res
                hClose hdl
                return res
