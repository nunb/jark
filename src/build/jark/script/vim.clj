(ns build.jark.script.vim
  (:use [build.jark.script]
        [pallet.script :only [defscript]]))

(defscript start 
  {:examples ["jark vim start"]
   :doc "Start a local VimClojure server with minimum dependencies."
   :required-args []
   :args-info [{:var "port" :default "2443" :long "port" :short "p"
                :description "Port to run VimClojure server"}]}
  [])

(defactimpl start [:linux] 
  exit 0
  )

(defactimpl start [:windows]
  (echo "not implemented")
  (exit 1))
