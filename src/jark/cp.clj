(ns jark.cp
  (:use [clojure.string :only (split)])
  (:import (java.net URL URLClassLoader))
  (:import (jark ClassPath))
  (:import (com.stuartsierra ClasspathManager))
  (:gen-class))

(defn ls []
  (let [cps (distinct (split (System/getProperty "java.class.path") #":"))]
    cps))

(defn add [path]
  (let [url (URL. (str "file://" path))]
    (println url)
    (. (new ClassPath) url)))
    

