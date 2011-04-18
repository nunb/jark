(ns jark.gen-script
  (:use [jark.script :only [gen-module-set defmodule]])
  (:require [jark.script.cp :as cp]
            [jark.script.vim :as vim]))

(def windows-dir "src/wrappers/windows")
(def linux-dir "src/wrappers/linux")

;;; define modules ;;;

(defmodule cp
  "Utilities to manipulate the classpath"
  [cp/remove 
   cp/ls])

(defmodule vim
  "Module to manage VimClojure instances"
  [vim/start])

;;; generate modules ;;;

(gen-module-set windows-dir [:windows] "bat"
  [cp "cp"]
  [vim "vim"])
(gen-module-set linux-dir [:linux] "sh"
  [cp "cp"]
  [vim "vim"])

; TODO breadth first?

(comment 
(gen-module-sets cp-module
  ["src/wrappers/mac" [:mac] "sh"]
  ["src/wrappers/linux" [:linux] "sh"]))
