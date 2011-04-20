(ns build.jark.script
  (:use [midje.sweet]
        [pallet.script :only [defscript defimpl with-script-context]]
        [pallet.stevedore :only [script do-script]]))


;; Private function from pallet.stevedore
(defn- ^String add-quotes
  "Add quotes to the argument s as a string"
  [s]
  (str "\"" s "\""))

(defscript doc-fn [name doc examples args-info])

(defimpl doc-fn [:linux]
         [name fn-doc examples args-info]
         (defn ~name []
           (echo ~fn-doc)
           (echo ~@examples)
           (echo ~@(keys args-info))))

(defn- define [[type long short doc default :as args]]
  (str "DEFINE_" (name type) " "
       (apply str (interpose " " (map add-quotes [long default doc short])))))

(fact (define [:string "host" "localhost" "vimclojure host" "h"]) => "DEFINE_string \"host\" \"h\" \"vimclojure host\" \"localhost\"")

(defscript declare-args [& args])

(defimpl declare-args :default
         [& args]
         ~@(interpose \newline (map define args))
         "FLAGS \"$@\" || exit $?"
         "eval set -- \"${FLAGS_ARGV}\""
         )

(fact (with-script-context [:default]
        (script 
          (~declare-args [:string "host" "localhost" "vimclojure host" "h"]
             [:string "host" "localhost" "vimclojure host" "h"])))
      => "DEFINE_string \"host\" \"h\" \"vimclojure host\" \"localhost\" \n DEFINE_string \"host\" \"h\" \"vimclojure host\" \"localhost\"\nFLAGS \"$@\" || exit $?\neval set -- \"${FLAGS_ARGV}\"\n")

