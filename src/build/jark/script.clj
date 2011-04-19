(ns build.jark.script
  (:require [clojure.contrib.pprint]
            [pallet.resource.directory])
  (:use [pallet.stevedore]
        [midje.sweet]))




;; TODO see tests
(defn- gen-action [env act]
  (pallet.script/with-template env
    (script
      ~(act)
      )))


(defmulti gen-module (fn [env _] env))

(defmethod gen-module [:linux]
  [env module]
  (let [actions (map (partial gen-action env) module)
        module-doc (format "DOC= \" %s \"" (-> (meta module) :doc))
        includes [". ${JARK_BIN}/shflags"]
        script (cons module-doc (concat includes actions))]
    (apply str script)))


;; TODO get fname from module's symbol name
;; Rethink name? output-module-set ... it mainly
;; spits to files
(defn gen-module-set
  "Outputs a set of module scripts according to the environment."
  [dir env suffix & modules]
  (.mkdirs (clojure.java.io/file dir))
  (doseq [[script file-name] (map (fn [[m f]] [(gen-module env m) f]) 
                                  modules)]
    (spit (str dir "/" file-name "." suffix)
          script)))

(defmacro defmodule
  "Declare a jark module. Takes a doc string and a vector
  of actions"
  [name doc actions]
  `(def ~name ^{:doc ~doc}
     ~actions))

(defmacro defaction
  "defscript with metadata. Supports have :examples and :doc
  metadata. Todo :args"
  [name m & args]
  (let [name (with-meta name (merge (meta name) (or m {})))]
    `(pallet.script/defscript ~name ~@args)))


(defn- gen-linux-doc-function [script-name doc examples args]
  `(defn ~(symbol (str (name script-name) "_doc")) []
     ~(str "echo \"" doc \")
     "echo \"\\n\""
     ~@(map (fn [e] (str "echo " \" e \")) examples)
     "echo \"\\n"
     ~@(map (fn [arg]
              (str "echo \"\\t" (name (:var arg))
                   " (--" (:long arg) " -" (:short arg) ")"
                   " -- " (:description arg) \")) 
            args)
     "exit 0"))


(defn- gen-linux-function [script-name required-args args body]
  (let [decargs (map (fn [a]
                       (str "DEFINE_string '" (name (:var a)) "' "
                            "'" (:default a) "' "
                            "'" (:description a) "' "
                            "'" (:short a) "' ")) args)
         assignargs (map (fn [n] (str n "=${FLAGS_" n "}")) (map :var args))]
    `(defn ~script-name [~@required-args]
       ~@decargs
       "FLAGS $@ || exit 1"
       "eval set -- \"${FLAGS_ARGV}\""
       ~@assignargs
       ~@body)))


(defmacro defactimpl
  "Define an implementation of an action (function)"
  [script-name specialisers & body]
  (when (some #{:windows} specialisers)
    `(defimpl ~script-name ~specialisers [] 
       ~(str ":" script-name)
       ~@body
       GOTO:EOF))
  (when (some #{:linux} specialisers)
    (let [m (meta (resolve script-name))]
      `(defimpl ~script-name ~specialisers []
         (gen-linux-doc-function script-name (:doc m) (:examples m) (:args-info m))
         (gen-linux-function script-name (:required-args m) (:args-info m) body)))))
