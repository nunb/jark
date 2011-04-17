(ns jark.gen-script
  (:use [jark.script :only [gen-module-set defmodule]])
  (:require [jark.script.cp :as cp]
            [jark.script.vim :as vim]))

(def windows-dir "modules/windows")
(def linux-dir "modules/linux")

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
  ["modules/mac" [:mac] "sh"]
  ["modules/linux" [:linux] "sh"]))
