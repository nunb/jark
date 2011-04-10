(ns jark.ns
  (:use clojure.contrib.pprint)
  (:use clojure.contrib.ns-utils)
  (:use clojure.contrib.find-namespaces)
  (:refer-clojure :exclude [list load find alias])
  (:import (java.io File FileNotFoundException))
  (:import (java.io File FileNotFoundException))
  (:use clojure.contrib.json))

(defn- ns-doc [] "Namespace utilities")

(defn- namespaces []
  (find-namespaces-on-classpath))

(defn- starting-with [module]
  (if (= (count (namespaces)) 0)
    (sort (filter #(. (str %) startsWith module) (namespaces)))
    (sort (filter #(. (str %) startsWith module) (map #(ns-name %) (all-ns))))))

(defn require-ns [n]
  (require (symbol n)))

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

(defn load
  "Loads the given clj file, and adds relative classpath"
  [file]
  (let [basename (.getParentFile (File. file))]
    (jark.cp/add (str (. System getProperty "user.home") (.toString basename))))
  (load-file file))

(defn run
  "runs the given main function"
  [main-ns & args]
  (require-ns main-ns)
  (apply (resolve (symbol (str main-ns "/-main"))) args))

(defn repl
  "Launch a repl with given ns"
  [namespace]
  (clojure.main/repl
    :init  (fn [] (in-ns (symbol namespace)))
   
    :prompt #(printf
              "\033[1;38;5;51m%s\033[1;38;5;45m>>\033[0m "
               (ns-name *ns*))
    :print (try
             (fn [x]
               (print "\033[38;5;77m")
               ((resolve 'clojure.contrib.pprint/pprint) x)
               (print "\033[m")
               (flush))
             (catch Exception e
               (prn e)))
    :caught (fn [x]
              (print "\033[38;5;220m")
              (prn x)
              (print "\033[m")
              (flush))))


(defn -main []
  (+  2 2))
