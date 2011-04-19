(ns jark.package
  (:gen-class)
  (:require cljr.main cljr.core)
  (:refer-clojure :exclude [list find alias]))

(defn list []
  (let [dependencies (:dependencies (cljr.core/get-project))]
    (into {} (map #(vector (first %) (second %)) dependencies))))
