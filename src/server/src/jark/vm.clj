(ns jark.vm
  (:gen-class)
  (:use clojure.contrib.server-socket)
  (:require [clojure.tools.nrepl :as nrepl])
  (:use clojure.contrib.pprint)
  (:import (jark SystemThreadList))
  (:import (java.lang.management RuntimeMXBean ManagementFactory))
  (:import (java.util Date)))

(defn used-mem []
  (let [rt (. Runtime getRuntime)]
    (- (. rt totalMemory) (. rt freeMemory))))

(defn free-mem []
  (let [rt (. Runtime getRuntime)]
    (. rt freeMemory)))

(defn total-mem []
  (let [rt (. Runtime getRuntime)]
    (. rt totalMemory)))

(defn run-gc []
  (let [rt (. Runtime getRuntime)]
    (loop [m1 (used-mem)
	   m2 1000000000000
	   i 0]
	(. rt runFinalization)
	(. rt gc)
	(. Thread yield)
	(if (and (< i 500)
	      (< m1 m2))
	  (recur (used-mem) m1 (inc i))))))

(defn gc []
  (loop [i 0]
    (run-gc)
    (if (< i 4)
      (recur (inc i)))))

(defn mb [bytes]
  (int (/ bytes (* 1024.0 1024.0))))

(defn mins [ms]
  (int (/ ms 60000.0)))

(defn secs [ms]
  (int (/ ms 1000.0)))

(defn stats
  "Display current statistics of the JVM"
  []
  (let [mx    (ManagementFactory/getRuntimeMXBean)
        props {"Port (vm)"    9000
               "Port (swank)" 4005
               "Mem total"    (str (mb (total-mem)) " MB")
               "Mem used"     (str (mb (used-mem))  " MB")
               "Mem free"     (str (mb (free-mem))  " MB")
               "Start time"   (.toString (Date. (.getStartTime mx)))
               "Uptime"       (str
                               (.toString (mins (.getUptime mx))) "m" " | "
                               (.toString (secs (.getUptime mx))) "s")}]
    props))

(defn uptime
  "Display uptime of the JVM"
  []
  (let [mx    (ManagementFactory/getRuntimeMXBean)
        uptime (str (.toString (.getUptime mx)) "ms")]
    uptime))

(defn stop []
  (. System (exit 0)))

(defn threads
  "Display all running threads"
  []
  (let [stl (SystemThreadList.)]
    (map #(.getName %) (.getAllThreads stl))))

(defn -main [& args]
  (create-repl-server 9500)
  (nrepl/start-server 9000)
  (System/setSecurityManager nil))
