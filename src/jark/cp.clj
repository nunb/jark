(ns jark.cp
  (:use [clojure.string :only (split)])
  (:import (java.net URL URLClassLoader))
  (:import (com.stuartsierra ClasspathManager))
  (:gen-class))

(defn ls []
  (let [cps (distinct (split (System/getProperty "java.class.path") #":"))]
    cps))

(defn add [path]
  (let [paths (System/getProperty "java.class.path")
        newcp (str paths ":" path)]
    (do 
      (System/setProperty "java.class.path" newcp)
      nil)))
