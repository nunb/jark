(ns jark.script
  (:require clojure.contrib.pprint
            pallet.resource.directory)
  (:use pallet.stevedore))


(defmacro defaction
  "defscript with metadata. Supports have :examples and :doc
  metadata. Todo :args"
  [name m & args]
  (let [name (with-meta name (merge (meta name) (or m {})))]
    `(pallet.script/defscript ~name ~@args)))

;; TODO get rid of fname
(defn gen-module-set
  "Outputs a set of module scripts according to the environment."
  [dir env suffix & modules]
  (.mkdirs (clojure.java.io/file dir))
  (doseq [[module fname] modules]
    (let [s (for [act module]
              (pallet.script/with-template env
                (script (~(-> (meta act) :name)))))]
      (spit (str dir "/" fname "." suffix) 
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

