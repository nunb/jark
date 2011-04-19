(defproject jark "0.4"
  :description "JARK build system"
  :dev-dependencies [[org.clojars.autre/lein-vimclojure "1.0.0"]]

  :dependencies [[org.clojure/clojure "1.2.0"]
                 [org.clojure/clojure-contrib "1.2.0"]
                 [midje "1.1"]
                 [org.cloudhoist/pallet "0.5.0-SNAPSHOT":exclusions [org.jclouds/jclouds-core]]]

  :repositories  {"sonatype"
                  "http://oss.sonatype.org/content/repositories/releases"
                  "sonatype-snapshots"
                  "http://oss.sonatype.org/content/repositories/snapshots"}

  :aot [leiningen.build-jark build.jark.gen-script]) 
