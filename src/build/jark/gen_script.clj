(ns build.jark.gen-script
  (:gen-class)
  (:use [pallet.stevedore :only [do-script]])
  (:require [build.jark.script.cp :as cp]
            [build.jark.script.vim :as vim]))

(def windows-dir "src/wrappers/windows")
(def linux-dir "src/wrappers/linux")

;;; define modules ;;;

;;; generate modules ;;;

(defn -main [] 

  (spit (str linux-dir "/vim.sh") vim/vim-module)
  )
  

; TODO breadth first?
(comment 
(gen-module-sets cp-module
  ["src/wrappers/mac" [:mac] "sh"]
  ["src/wrappers/linux" [:linux] "sh"]))
