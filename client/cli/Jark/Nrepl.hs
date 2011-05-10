module Jark.Nrepl
( eval )
where 
  
import Network
import System.IO (hGetContents, hFlush, hClose, hPutStr, hSetBuffering, stdout, BufferMode(..))

port = 9000
ip   = "localhost"

eval :: String -> IO String
eval expr = withSocketsDo $ do
       hdl <- connectTo "localhost" (PortNumber 9000)
       hSetBuffering hdl NoBuffering          
       hPutStr hdl "test message"
       res <- hGetContents hdl
       mapM_ (\x -> putStr (show x) >> hFlush stdout) res
       hClose hdl
       return res
