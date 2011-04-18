(ns jark.script
  (:require [clojure.contrib.pprint])
  (:require pallet.resource.directory)
  (:use [midje.sweet] [pallet.stevedore]))

;; TODO get fname from module's symbol name

(defmulti gen-module (fn [env _] env))

(defmethod gen-module [:linux]
  [env module]
  (let [functions (let [s (for [act module]
                            (pallet.script/with-template env
                              (script (~(-> (meta act) :name)))))]
                    (apply str (interpose "\n" s)))
        docs (format "DOC= \" %s \"" (-> (meta module) :doc))
        includes [". ${JARK_BIN}/shflags"]
        script (map (fn [& t] (->> (concat includes t)
                                   (interpose "\n")
                                   (apply str)))
                    docs functions)]
    script))

(defmethod gen-module [:windows]
  [env module]
  "TODO")

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

(let [examples ["test1 test2"]
      doc "test1 doc"
      args []]
  (defaction test1
             {:examples examples
              :doc doc
              :args args}
             [])
  (fact (-> (meta test1) :examples) => examples)
  (fact (-> (meta test1) :doc) => doc)
  (fact (-> (meta test1) :args) => args))

(defmacro defactimpl
  "Define an implementation of an action (function)"
  [script-name specialisers & body]
  (when (some #{:windows} specialisers)
  `(defimpl ~script-name ~specialisers [] 
     ~(str ":" script-name)
     ~@body
     GOTO:EOF))
  (when (some #{:linux} specialisers)
   (let [required-args (-> (meta (resolve script-name)) :required-args)
         examples (-> (meta (resolve script-name)) :examples)
         actdoc (-> (meta (resolve script-name)) :doc)
         args (-> (meta (resolve script-name)) :args-info)
         vars (map :var args)
         decargs (map (fn [a]
                        (str "DEFINE_string '" (name (:var a)) "' "
                             "'" (:default a) "' "
                             "'" (:description a) "' "
                             "'" (:short a) "' ")) args)
         assignargs (map (fn [n] (str n "=${FLAGS_" n "}")) vars)]
  `(defimpl ~script-name ~specialisers []
     (defn ~(symbol (str (name script-name) "_doc")) []
       ~(str "echo \"" actdoc \")
       "echo \"\\n\""
       ~@(map (fn [e] (str "echo " \" e \")) examples)
       "echo \"\\n"
       ~@(map (fn [arg]
                (str "echo \"\\t" (name (:var arg))
                     " (--" (:long arg) " -" (:short arg) ")"
                     " -- " (:description arg) \")) args)
       "exit 0")
     (defn ~script-name [~@required-args]
       ~@decargs
       "FLAGS $@ || exit 1"
       "eval set -- \"${FLAGS_ARGV}\""
       ~@assignargs
       ~@body)))))

