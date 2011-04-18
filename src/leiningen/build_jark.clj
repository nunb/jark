(ns leiningen.build-jark
  (:require [jark.gen-script :as jark])
  (:require [clojure.java.io :as io]
            [clojure.string  :as str])
  (:import (java.io File FileReader PushbackReader
                    FileWriter BufferedReader InputStreamReader)))

(defn cmd [p] (.. Runtime getRuntime (exec (str p))))

(defn cmdout [o]
  (let [r (BufferedReader.
           (InputStreamReader.
            (.getInputStream o)))]
    (dorun (map println (line-seq r)))))

(defn ls
  [path]
  (let [file (java.io.File. path)]
    (if (.isDirectory file)
      (seq (.list file))
      (when (.exists file)
        [path]))))


(defn mkdir [path]
  (.mkdirs (io/file path)))

(defn ensure-dir!
  [path]
  (when-not (ls path)
    (mkdir path)))

(defn dir? [path]
  (.isDirectory (java.io.File. path)))

(defn build-server [project]
  (ensure-dir! "jark-server/classes")
  (println "Compiling java classes")
  (cmdout (cmd "javac -d jark-server/classes/ jark-server/src/jark/SystemThreadList.java"))
  (println "Creating jar"))

(defn build-jark [project]
  (println "Building, but not quite there yet ...")
  (jark/generate))


