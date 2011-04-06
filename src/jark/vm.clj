(ns jark.vm
  (:gen-class)
  (:use clojure.contrib.server-socket)
  (:require [clojure.tools.nrepl :as nrepl])
  (:use clojure.contrib.pprint)
  (:require [jark.core :as core])
  (:import (java.lang.management RuntimeMXBean ManagementFactory))
  (:import (java.util Date)))

(defn start [port]
  (nrepl/start-server (Integer. port)))

(defn connect [host port]
  (nrepl/connect host (Integer. port)))

(defn eval-expression [host port exp]
  (let [connection     (connect host port)
        repl           (:send connection)
        repl-seq       (comp nrepl/response-seq repl)
        repl-receive   (comp (fn [r#] (r#)) repl)
        repl-read      (comp nrepl/read-response-value repl-receive)
        repl-value     (comp :value repl-read)]
    (println (repl-value exp))
    (:close connection)))

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
        props {"VM port"      (read-string (slurp "/tmp/jark.port"))
               "swank port"   4005
               "total mem"    (str (mb (total-mem)) " MB")
               "used mem"     (str (mb (used-mem))  " MB")
               "free mem"     (str (mb (free-mem))  " MB")
               "start time"   (.toString (Date. (.getStartTime mx)))
               "uptime"       (str
                               (.toString (mins (.getUptime mx))) "m" " | "
                               (.toString (secs (.getUptime mx))) "s")}
        p     (mapcat #(vector (key %) (val %)) props)]
        (core/pp-plist p)))

(defn uptime
  "Display uptime of the JVM"
  []
  (let [mx    (ManagementFactory/getRuntimeMXBean)
        uptime (str (.toString (.getUptime mx)) "ms")]
    uptime))

(defn stop []
  (. System (exit 0)))

(defn -main [& args]
  ;(nrepl/start-server 9000)
  (create-repl-server 9000))
