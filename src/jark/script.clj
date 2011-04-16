(ns jark.script
  (:require clojure.contrib.pprint
            pallet.resource.directory)
  (:use pallet.stevedore))

(def windows-dir "modules/windows")
(def linux-dir "modules/linux")


;;; Helpers ;;;

(defmacro defaction
  "defscript with metadata. Supports have :examples and :doc
  metadata. Todo :args"
  [name m & args]
  (let [name (with-meta name (merge (meta name) (or m {})))]
    `(pallet.script/defscript ~name ~@args)))

(defn gen-module-set
  "Outputs a set of module scripts according to the environment."
  [dir env suffix & modules]
  (.mkdirs (clojure.java.io/file dir))
  (doseq [[module file] modules]
    (let [s (for [act module]
              (pallet.script/with-template env
                (script (~(-> (meta act) :name)))))]
      (spit (str dir "/" file "." suffix) 
            (apply str (interpose "\n" s))))))

(defmacro defmodule
  "Declare a jark module. Takes a doc string and a vector
  of actions"
  [name doc actions]
  `(def ~name ^{:doc ~doc} 
     ~actions))


;;;; Define scripts ;;;;

;; cp-remove ;;
(defaction cp-remove 
  {:examples ["jark cp remove <jar>"]
   :doc "Remove from the classpath for the current Jark server"
   :args [{:var 'path :long ["--path"] :short ["-p"]}]}
  [])

(defimpl cp-remove [:linux] []
  (defn remove [path]
    (echo "command not implemented yet")
    (exit 1)))

(defimpl cp-remove [:windows] []
  (defn remove [path]
    (echo "command not implemented yet (in windows)")
    (exit 1)))


;; cp-ls ;;

(defaction cp-ls
  {:examples ["jark cp ls"]
   :doc "List the classpath for the current Jark server"}
  [])
(defimpl cp-ls [:linux] []
  (defn ls []
    (jark jark.cp ls)
    (exit 0)))
(defimpl cp-ls [:windows] []
  (defn ls []
    (echo "command not implemented yet (in windows)")
    (exit 1)))


;;; define modules ;;;

(defmodule cp-module
  "Utilities to manipulate the classpath"
  [cp-remove
   cp-ls])

;;; generate modules ;;;

(gen-module-set windows-dir [:windows] "bat"
  [cp-module "cp"])
(gen-module-set linux-dir [:linux] "sh"
  [cp-module "cp"])


; TODO breadth first?
;
;(gen-module-sets cp-module
;  ["modules/mac" [:mac] "sh"]
;  ["modules/linux" [:linux] "sh"])

(comment (script
  (defn remove [jar]
    (echo "command not implemented yet")
    (exit 1))

  (defn add [jar]
    (when (-z @jar)
      (echo "USAGE jark cp add <jarpath>"))
    (when (-d @jar)))
  (defn ls []
    jark jark.cp ls)))
