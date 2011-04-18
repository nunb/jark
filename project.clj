(defproject jark "0.4"
  :description "JARK is a tool to manage classpaths and clojure namespaces on a persistent JVM"
  ;; :dev-dependencies [[org.clojars.autre/lein-vimclojure "1.0.0"]]

  :dependencies [[org.clojure/clojure "1.2.0"]
                 [org.clojure/clojure-contrib "1.2.0"]
                 [swank-clojure "1.2.0"]
                 [cljr "1.0.0-SNAPSHOT"]
                 [midje "1.1"]
                 [org.clojure/tools.nrepl "0.0.4"]
                 [org.cloudhoist/pallet "0.4.14"]
                 [org.cloudhoist/pallet-crates-all "0.4.2"]]

  :repositories  {"sonatype"
                  "http://oss.sonatype.org/content/repositories/releases"}

  :aot [jark.vm jark.cp jark.ns
        jark.swank jark.doc leiningen.build-jark]) 
