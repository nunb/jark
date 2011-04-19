(ns build.jark.script.cp
  (:refer-clojure :exclude [remove])
  (:use [build.jark.script]
        [pallet.script :only [defscript]]))

(defscript remove 
  {:examples ["jark cp remove <jar>"]
   :doc "Remove from the classpath for the current Jark server"
   :function-name 'remove
   :required-args ['path]
   :args-info [{:var "path" :default "." :long "path" :short "p"
                :description "Path to remove"}]}
  [])

(defactimpl remove [:linux]
  (echo "command not implemented yet")
  (exit 1))


(defscript ls
  {:examples ["jark cp ls"]
   :doc "List the classpath for the current Jark server"
   :function-name 'ls
   :required-args []
   :args-info []}
  [])

(defactimpl ls [:linux] 
  (jark "jark.cp ls")
  (exit 0))


(defscript run
  {:examples ["jark cp run main-class"]
   :doc "Run main-class on the current Jark server"
   :function-name 'run
   :required-args ['mainclass]
   :args-info [{:var "path" :default "" :long "path" :short "p"
                :description "Path to remove"}]}
  [])

(defactimpl run [:linux]
  (touch "classpath")
  (@JARK_CLIENT "jark.cp run @mainclass")
  (exit 0))
