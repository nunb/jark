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

;; TODO ideally we want to automate the function definition
;; in the script, along with any arguments, short/long arguments,
;; and a USAGE function.
;;
;; These should be defined only once with a defaction. Will probably
;; have to make a short wrapper around defimpl that wraps the script
;; in a sh/bat function definition like defactimpl
(defmacro defactimpl
  [script-name specialisers & body]
  (when (some #{:windows} specialisers)
  `(defimpl ~script-name ~specialisers [] 
     ~(str ":" script-name)
     ~@body
     GOTO:EOF))
  (when (some #{:linux} specialisers)
   (let [required-args (-> (meta (resolve script-name)) :required-args)
         args (-> (meta (resolve script-name)) :args-info)
         vars (map :var args)
         decargs (map (fn [a]
                        (str "DEFINE_string '" (name (:var a)) "' "
                             "'" (:default a) "' "
                             "'" (:description a) "' "
                             "'" (:short a) "' ")) args)
         assignargs (map (fn [n] (str n "=${FLAGS_" n "}")) vars)]
  `(defimpl ~script-name ~specialisers [] 
     (defn ~script-name [~@required-args]
       ~@decargs
       "FLAGS $@ || exit 1"
       "eval set -- \"${FLAGS_ARGV}\""
       ~@assignargs
       ~@body)))))


;;;; Define scripts ;;;;

;; cp-remove ;;
(defaction cp-remove 
  {:examples ["jark cp remove <jar>"]
   :doc "Remove from the classpath for the current Jark server"
   :required-args ["path"]
   :args-info [{:var "path" :default "." :long "path" :short "p"
                :description "Path to remove"}]}
  [])


(defactimpl cp-remove [:linux]
  (echo "command not implemented yet")
  (exit 1))

(defactimpl cp-remove [:windows]
  echo "command not implemented yet")



;; cp-ls ;;

(defaction cp-ls
  {:examples ["jark cp ls"]
   :doc "List the classpath for the current Jark server"
   :required-args []
   :args-info []}
  [])
(defactimpl cp-ls [:linux] 
  jark jark.cp ls
  exit 0)

(defactimpl cp-ls [:windows]
  ":ls"
  echo "command not implemented yet (in windows)"
  GOTO:EOF)


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
