module Jark.Nrepl
( send )
where 
  
import Network
import Data.Char (toLower)
import Text.Regex.Posix ((=~))
import System.IO (hGetLine,hClose,hPutStrLn,hSetBuffering,BufferMode(..),Handle,stdout)
import Jark.Util

port = 9000
ip   = "localhost"

send [input] = do
  h <- connectTo ip (PortNumber port)
  putStrLn $ "Connected to " ++ ip ++ ":" ++ show port
  hSetBuffering h LineBuffering
  while2 (send h) (receive h)

send h = do
  input <- getLine
  hPutStrLn h input
  return $ null input
 
receive h = do
  input <- hGetLine h
  putStrLn input
  return $ null input
