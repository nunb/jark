(ns jark.script.cp
  (:refer-clojure :exclude [remove])
  (:use jark.script))

;; cp-remove ;;
(defaction remove 
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

(defactimpl remove [:windows]
  echo "command not implemented yet")



;;; cp-ls ;;;
(defaction ls
  {:examples ["jark cp ls"]
   :doc "List the classpath for the current Jark server"
   :function-name 'ls
   :required-args []
   :args-info []}
  [])

(defactimpl ls [:linux] 
  (jark jark.cp ls)
  (exit 0))

(defactimpl ls [:windows]
  echo "command not implemented yet (in windows)"
)
