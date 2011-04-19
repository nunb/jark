(defproject jark-server "0.4"
  :description "JARK server utilities"

  :dependencies [[org.clojure/clojure "1.2.0"]
                 [org.clojure/clojure-contrib "1.2.0"]
                 [swank-clojure "1.2.0"]
                 [org.clojure/tools.nrepl "0.0.4"]
                 [cljr "1.0.0-SNAPSHOT" :exclusions [org.clojure/clojure org.clojure/clojure-contrib]]]
  
  :aot [jark.vm jark.cp jark.ns jark.swank jark.doc]) 
