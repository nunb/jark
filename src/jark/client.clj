(ns jark.client
  (:use clojure.contrib.json)
  (:refer-clojure :exclude [send])
  (:require [clojure.tools.nrepl :as nrepl]))

;; TODO: Write this client in C

(defn connect [host port]
  (nrepl/connect host (Integer. port)))

(defn eval-expression [host port exp]
  (let [connection     (connect host port)
        repl           (:send connection)
        repl-seq       (comp nrepl/response-seq repl)
        repl-receive   (comp (fn [r#] (r#)) repl)
        repl-read      (comp nrepl/read-response-value repl-receive)
        repl-value     (comp :value repl-read)
        json-rep       (json-str (repl-value exp))]
    (println json-rep)
    (:close connection)))

(defn send [exp]
  (eval-expression "127.0.0.1" 9000 exp))
