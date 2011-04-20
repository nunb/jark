(ns build.jark.script
  (:use [pallet.script :only [defscript defimpl]]))


;; Private function from pallet.stevedore
(defn- ^String add-quotes
    "Add quotes to the argument s as a string"
    [s]
    (str "\"" s "\""))

(defscript doc-fn [name doc examples args-info])

(defimpl doc-fn [:linux]
  [name fn-doc examples args-info]
  (defn ~name []
    (echo ~fn-doc)
    (echo ~@examples)
    (echo ~@(keys args-info))))


(defmulti emit-arg-fn 
  "Emit a shFlags argument declaration"
  (fn [& args] (identity (first args))))

(defmulti emit-arg-fn 'define-string 
  [[type long name doc short :as args]]
  (let [args (map add-quotes args)]
    (apply str "DEFINE_string " args)))

(defmulti emit-arg-fn 'define-integer 
  [[type long name doc short :as args]]
  (let [args (map add-quotes args)]
    (apply str "DEFINE_integer " args)))

(defmulti emit-arg-fn 'define-boolean 
  [[type long name doc short :as args]]
  (let [args (map add-quotes args)]
    (apply str "DEFINE_boolean " args)))

(defmulti emit-arg-fn 'define-float 
  [[type long name doc short :as args]]
  (let [args (map add-quotes args)]
    (apply str "DEFINE_float " args)))

(defscript declare-args [& args])

(defimpl declare-args :default
  [& args]
  ~@(map emit-arg-fn args)
  "FLAGS \"$@\" || exit $?"
  "eval set -- \"${FLAGS_ARGV}\""
  )
