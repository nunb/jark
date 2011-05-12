module Jark.Nrepl
( eval )
where 
  
import Network
import System.IO

port = 9000
host = "localhost"

eval :: String -> IO String
eval expr = do
  putStrLn expr
  return expr
      
evalExpr :: String -> IO String
evalExpr expr = withSocketsDo $ do
                hdl <- connectTo host (PortNumber 9000)
                hSetBuffering hdl NoBuffering          
                hPutStr hdl "test message"
                res <- hGetContents hdl
                mapM_ (\x -> putStr (show x) >> hFlush stdout) res
                hClose hdl
                return res

decode :: String -> String 
decode res = res

getId :: String
getId = host


