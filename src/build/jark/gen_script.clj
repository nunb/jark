(ns build.jark.gen-script
  (:gen-class)
  (:use [build.jark.script :only [gen-module-set]])
  (:require [build.jark.script.cp :as cp]
            [build.jark.script.vim :as vim]))

(def windows-dir "src/wrappers/windows")
(def linux-dir "src/wrappers/linux")

;;; define modules ;;;

(def cp
  ^{:doc "Utilities to manipulate the classpath"}
  [cp/remove 
   cp/ls
   cp/run])

(def vim
  ^{:doc "Module to manage VimClojure instances"}
  [vim/start])

;;; generate modules ;;;

(defn -main [] 
  
  #_(gen-module-set windows-dir [:windows] "bat"
                  [cp "cp"]
                  [vim "vim"])
  (gen-module-set linux-dir [:linux] "sh"
                  [cp "cp"]
                  [vim "vim"]))

; TODO breadth first?
(comment 
(gen-module-sets cp-module
  ["src/wrappers/mac" [:mac] "sh"]
  ["src/wrappers/linux" [:linux] "sh"]))
