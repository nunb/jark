(ns leiningen.build-jark
  (:import (java.io File FileReader PushbackReader
                    FileWriter BufferedReader InputStreamReader)))


(defn cmd [p] (.. Runtime getRuntime (exec (str p))))

(defn cmdout [o]
  (let [r (BufferedReader.
           (InputStreamReader.
            (.getInputStream o)))]
    (dorun (map println (line-seq r)))))

(defn build-jark [project]
  (println "Building, but not quite there yet ..."))
