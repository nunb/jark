(defproject jark "develop"
  :description "JARK build system"
  :dev-dependencies [[org.clojars.autre/lein-vimclojure "1.0.0"]]

  :dependencies [[org.clojure/clojure "1.2.0"]
                 [org.clojure/clojure-contrib "1.2.0"]
                 [swank-clojure "1.3.0"]
                 [org.clojure/tools.nrepl "0.0.4"]
                 [midje "1.1"]
                 [org.cloudhoist/stevedore "0.5.0-SNAPSHOT"]
                 [fs "0.7.1"]]

  :repositories  {"sonatype"
                  "http://oss.sonatype.org/content/repositories/releases"
                  "sonatype-snapshots"
                  "http://oss.sonatype.org/content/repositories/snapshots"}

  :aot [leiningen.build-jark build.jark.gen-script]) 
