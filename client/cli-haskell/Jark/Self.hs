module Jark.Self
( install )
where 
  
import Network.Curl  
  
packages :: [(String, String)]  
packages =  [ ("clojure-1.2.0"  , "http://build.clojure.org/releases/org/clojure/clojure/1.2.0/clojure-1.2.0.jar")
            , ("clojure-contrib-1.2.0", "http://build.clojure.org/releases/org/clojure/clojure-contrib/1.2.0/clojure-contrib-1.2.0.jar")
            , ("tools.nrepl-0.0.5", "http://repo1.maven.org/maven2/org/clojure/tools.nrepl/0.0.5/tools.nrepl-0.0.5.jar")]
  
install :: IO ()
install =  do mapM download ["clojure-1.2.0", "clojure-contrib-1.2.0", "tools.nrepl-0.0.5"]
              putStrLn $ "completed installation."
  
download :: String -> IO ()
download package = do let (Just url) = lookup package packages
                      putStrLn $ "downloading " ++ package ++ " ..."
                      let s = curlGetString url []
                      (code, text) <- s
                      let path = "/tmp/" ++ package ++ ".jar"
                      writeFile path text
