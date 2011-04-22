(ns build.jark.gen-script
  (:gen-class)
  (:use [pallet.stevedore :only [script]]
        [pallet.script :only [with-script-context]])
  (:require [build.jark.script.cp :as cp]
            [build.jark.script.vim :as vim]))

(def windows-dir "src/wrappers/windows")
(def linux-dir "src/wrappers/linux")

(defn -main [] 
  (spit (str linux-dir "/vim.sh")
        (with-script-context [:linux]
          (script
            (~vim/vim-module)))))
