(ns jark.cp
  (:use [clojure.string :only (split)])
  (:import (java.net URL URLClassLoader))
  (:import (com.stuartsierra ClasspathManager))
  (:import (java.lang.reflect Method))
  (:import (java.io File))
  (:use clojure.contrib.classpath)
  (:gen-class))

(defn ls []
  (let [urls (seq (.getURLs (java.lang.ClassLoader/getSystemClassLoader)))]
    (map (memfn toString) urls))) 
  
(defn add [#^String jarpath] 
 (let [#^URL url   (.. (File. jarpath) toURI toURL) 
       cls         (. (URLClassLoader. (into-array URL [])) getClass) 
       acls        (into-array Class [(. url getClass)]) 
       aobj        (into-array Object [url]) 
       #^Method m  (. cls getDeclaredMethod "addURL" acls)]
   (doto m
     (.setAccessible true) 
     (.invoke (ClassLoader/getSystemClassLoader) aobj))
   nil))

(defn exists? [path]
  (some #(= path %) (ls)))
