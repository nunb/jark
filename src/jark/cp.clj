(ns jark.cp
  (:use [clojure.string :only (split)])
  (:import (java.net URL))
  (:require jark.ns)
  (:import (com.stuartsierra ClasspathManager))
  (:gen-class))

(defn ls []
  (let [cps (distinct (split (System/getProperty "java.class.path") #":"))]
    cps))

(defn add [path]
  (let [url (URL. (str "file://" path))]
    (clojure.lang.RT/addURL url)))

(defn run []
  (com.stuartsierra.ClasspathManager "jark.ns"))

