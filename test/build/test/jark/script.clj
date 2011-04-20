(ns build.test.jark.script
  (:require [build.jark.script.vim])
  (:use [build.jark.script]
        [pallet.stevedore :only [script]]
        [pallet.script :only [defscript with-script-context]]
        [midje.sweet]))

;;; Test gen-module

; start Setup
(with-script-context
  [:linux]
  (script
    @#'build.jark.script.vim/start))

