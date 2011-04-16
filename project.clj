(defproject jark "1.0"
  :description "JARK is a tool to manage classpaths and clojure namespaces on a persistent JVM"
  :dev-dependencies [[org.clojars.autre/lein-vimclojure "1.0.0"]]

  :dependencies [[org.clojure/clojure "1.2.0"]
                 [org.clojure/clojure-contrib "1.2.0"]
                 [swank-clojure "1.2.0"]
                 [cljr "1.0.0-SNAPSHOT"]
                 [org.clojure/tools.nrepl "0.0.4"]
                 [org.cloudhoist/pallet "0.4.15"]
                 [org.cloudhoist/pallet-crates-standalone "0.4.2"]]

  :repositories  {"stuartsierra" "http://stuartsierra.com/maven2"}

  :aot [jark.vm jark.cp jark.ns jark.swank jark.doc]) 
