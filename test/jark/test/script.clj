(ns jark.test.script
  (:use [jark.script]
        [pallet.stevedore :only [script]]
        [midje.sweet]))

;;; Test gen-action
(fact 
  (let [generated-script (@#'jark.script/gen-action 
                              [:linux] 
                              (fn [] jark.script.vim/start))]
    generated-script => (contains "function start()")
    generated-script => (contains "function start_doc()")))

;;; Test defaction
(let [examples ["test1 test2"]
      doc "test1 doc"
      args []]
  (defaction test1
             {:examples examples
              :doc doc
              :args args}
             [])

  (fact "Metadata is correctly added"
        (meta test1) => (contains {:examples examples
                                   :doc doc
                                   :args args})))
;;; Test gen-linux-doc-function
(let [generated-script (script ~(@#'jark.script/gen-linux-doc-function 
                                     'test 
                                     "doc dos e s"
                                     ["jark vim sd" "jark vim sd"]
                                     [{:var 'a :default "asd" :description "Description" :long "long" :short "l"}]))]
  (fact 
    generated-script => (has-prefix "function test_doc()")))


;;; Test gen-linux-function
(let [generated-script (script ~(@#'jark.script/gen-linux-function 
                                     'test
                                     ['a 'b]
                                     [{:var 'a :default "asd" :description "Description" :long "long" :short "l"}]
                                     ["asdf asdf" "asdfwef"]))]
  (fact 
    generated-script => (has-prefix "function test()")))
