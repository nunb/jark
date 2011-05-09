module Jark.Nrepl
( send )
where 
  
import Network
import Data.Char (toLower)
import Text.Regex.Posix ((=~))
import System.IO (hGetLine,hClose,hPutStrLn,hSetBuffering,BufferMode(..),Handle,stdout)

port = 9000
ip   = "localhost"

untilM p x = x >>= (\y -> if p y then return y else untilM p x) 
-- repeats two actions until either returns true
while2 x y = ifM x (return ()) $ ifM y (return ()) $ while2 x y 
-- monadic `if`
ifM p t f  = p >>= (\p' -> if p' then t else f)

client = do
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
