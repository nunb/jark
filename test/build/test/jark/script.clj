(ns build.test.jark.script
  (:require [build.jark.script.vim])
  (:use [build.jark.script]
        [pallet.stevedore :only [script]]
        [pallet.script :only [defscript]]
        [midje.sweet]))

;;; Test gen-action
(fact 
  (let [generated-script (@#'build.jark.script/gen-action 
                              [:linux] 
                              build.jark.script.vim/start)]
    generated-script => (contains "function start()")
    generated-script => (contains "function start_doc()")))


;;; Test defscript
(defscript test1 {:examples ["test1 test2"]
                  :doc "test1 doc"
                  :args "asdf"} [])
(fact "Metadata is correctly added"
      (keys (meta #'test1)) => (contains [:examples :doc :args] :in-any-order))

;;; Test gen-linux-doc-function
(let [generated-script (script ~(@#'build.jark.script/gen-linux-doc-function 
                                     'test 
                                     "doc dos e s"
                                     ["jark vim sd" "jark vim sd"]
                                     [{:var 'a :default "asd" :description "Description" :long "long" :short "l"}]))]
  (fact 
    generated-script => (has-prefix "function test_doc()")))

;;; Test gen-linux-function
(let [generated-script (script ~(@#'build.jark.script/gen-linux-function 
                                     'test
                                     ['a 'b]
                                     [{:var 'a :default "asd" :description "Description" :long "long" :short "l"}]
                                     ["asdf asdf" "asdfwef"]))]
  (fact 
    generated-script => (has-prefix "function test()")))

;;; Test gen-module

; start Setup
(defscript start 
  {:examples ["jark vim start"]
   :doc "Start a local VimClojure server with minimum dependencies."
   :required-args []
   :args-info [{:var "port" :default "2443" :long "port" :short "p"
                :description "Port to run VimClojure server"}]}
  [])

(defactimpl start [:linux] 
  (echo "this is a test")
  (exit 1)
  )

(def vim
  ^{:doc "Utilities to manipulate the classpath"}
  [start]) 
;end setup

(let [generated-script (gen-module [:linux] vim)]
  (fact
    generated-script => (contains "DOC=")
    generated-script => (contains "function start()")
    generated-script => (contains "function start_doc()"))
  (future-fact "generate module doc/usage function"
    generated-script => (contains "function _doc()")))

