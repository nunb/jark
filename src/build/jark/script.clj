(ns build.jark.script
  (:require [clojure.contrib.pprint]
            [pallet.resource.directory])
  (:use [midje.sweet]))


(defn- gen-action 
  "Generate a script in the context of an environment"
  [env act]
  (pallet.script/with-script-context env
    (pallet.stevedore/script
      (~act)
      )))

(defmulti gen-module (fn [env _] env))

(defmethod gen-module [:linux]
  [env module]
  (let [actions (map (partial gen-action env) module)
        module-doc (format "DOC=\"%s\"\n" (-> (meta module) :doc))
        includes [". ${JARK_BIN}/shflags\n"]
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


(defn- gen-linux-doc-function [script-name doc examples args]
  `(defn ~(symbol (str (name script-name) "_doc")) []
     ~(str "echo \"" doc \")
     "echo"
     ~@(map (fn [e] (str "echo " \" e \")) examples)
     ~@(map (fn [arg]
              (str "echo \"  " (name (:var arg))
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
  "Define an implementation of a function. A documentation function
  will be generated called 'script-name'_doc."
  [script-name specialisers & body]
  (when (some #{:windows} specialisers)
    `(pallet.script/defimpl ~script-name ~specialisers [] 
       ~(str ":" script-name)
       ~@body
       GOTO:EOF))
  (when (some #{:linux} specialisers)
    (let [m (meta (resolve script-name))]
      `(pallet.script/defimpl ~script-name ~specialisers []
         ~(gen-linux-doc-function script-name (:doc m) (:examples m) (:args-info m))
         ~(gen-linux-function script-name (:required-args m) (:args-info m) body)))))
