(ns jark.cp
  (:use [clojure.string :only (split)])
  (:gen-class))

(defn ls []
  (let [cps (distinct (split (System/getProperty "java.class.path") #":"))]
    (doseq [i cps]
      (when-not (= i "")
        (println i)))))
