(ns jark.ns
  (:gen-class)
  (:use clojure.contrib.pprint)
  (:use clojure.contrib.ns-utils)
  (:use clojure.contrib.find-namespaces)
  (:refer-clojure :exclude [list find alias])
  (:import (java.io File FileNotFoundException))
  (:require jark.cp)
  (:use clojure.contrib.json))

(defn- namespaces []
  (find-namespaces-on-classpath))

(defn- starting-with [module]
  (if (= (count (namespaces)) 0)
    (sort (filter #(. (str %) startsWith module) (namespaces)))
    (sort (filter #(. (str %) startsWith module) (map #(ns-name %) (all-ns))))))

(defn list
  "List all namespaces in the classpath. Optionally takes a namespace prefix"
  ([]
     (sort (namespaces)))
  ([module]
     (starting-with module)))

(defn find
  "Find all namespaces containing the given name"
  [module]
  (starting-with module))

(defn load-clj
  "Loads the given clj file, and adds relative classpath"
  [file]
  (let [basename (.getParentFile (File. file))]
    (jark.cp/add (.toString basename)))
  (load-file file))

(defn require-ns [n]
  (require (symbol n)))

(defn fun? [f]
  (instance? clojure.lang.IFn f))

(defn fns [n]
  (require-ns n)
  (let [namespace (symbol n)
        vars      (vec (ns-vars namespace))
        fns-list  (filter #(fun? %) vars)]
    (sort fns-list)))

(defn fn-args [n f]
  (nthnext
   (flatten (:arglists (meta (eval (read-string (format "#'%s/%s" n f)))))) 0))

(defn fn-doc [n f]
  (:doc (meta (eval (read-string (format "#'%s/%s" n f))))))

(defn fn-usage [n f]
  (str "USAGE: " f " " (fn-args n f)))

(defn help
  ([n]
     (require-ns n)
     (into {} (map #(vector % (fn-doc n %)) (fns n))))
  
  ([n f]
     (fn-usage n f)))

(defn about
  [n]
  (require-ns n)
  (println (let [p (into [] (fns n))]
                (cl-format true "~{~A ~}" p))))

(defn explicit-help [n f]
  (if (= f "help")
    (help n)
    (help n f)))

(defn apply-fn [n f & args]
  (apply (resolve (symbol (str n "/" f))) args))

(defn dispatch-ns
  [n]
  (try
    (require-ns n)
    (help n)
    (catch FileNotFoundException e (println "No such module" e))))

(defn dispatch
  "Dispatches to the right Namespace, Function and Args"
  ([n]
     (json-str (dispatch-ns n)))
  ([n f & args]
     (if (or (= (first args) "help") (= f "help"))
       (explicit-help n f)
       (do
         (require-ns n)
         (try
           (let [ret (apply (resolve (symbol (str n "/" f))) args)]
             (when ret
               (if (or (var? ret) (= (type ret) java.lang.Class))
                 ret
                 (json-str ret))))
           (catch IllegalArgumentException e (help n f))
           (catch NullPointerException e (println "No such command")))))))

(defn run
  "Runs the class/ns containing a -main function"
  [main-ns & args]
  (require-ns main-ns)
  (apply (resolve (symbol (str main-ns "/-main"))) args))

(defn cli-json
  "Run the cli interface for any namespace and return json"
  ([module]
     (try
       (require-ns module)
       (help module)
       (catch FileNotFoundException e (println "No such module" e))))
  ([module command & args]
     (if (or (= (first args) "help") (= command "help"))
       (explicit-help module command)
       (do
         (require-ns module)
         (try
           (let [ret (apply (resolve (symbol (str module "/" command))) args)]
             (when ret (do
                         (json-str ret))))
           (catch IllegalArgumentException e (help module command))
           (catch NullPointerException e (println "No such command")))))))
