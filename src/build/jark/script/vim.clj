(ns build.jark.script.vim
  (:use [build.jark.script]
        [midje.sweet]
        [pallet.script :only [defscript defimpl with-script-context]]
        [pallet.stevedore :only [script do-script]]))

(def start-attr
  ^{:doc "Attributes of the start function"}
  {:fn-doc "Start a local VimClojure server with minimum dependencies."
   :examples ["jark vim start"]
   :required-args []
   :opt-args [{:var "port" :default "2443" :long "port" :short "p"
                :description "Port to run VimClojure server"}]})

(defscript start [])

(defimpl start [:linux] []
  (defn start [port]
    (~declare-args
       [:string "host" "localhost" "vimclojure host" "h"]
       [integer "port" 2443 "vimclojure port" "p"])

    (when (not (file-exists? @VIMCLOJURE_JAR))
      (echo "FAILED VimClojure jar not installed")
      (echo "")
      (echo "Install instructions:")
      (echo "  jark vim install")
      (exit 1))

    (echo "Starting VimClojure server on port ${port} ...")
    (java -cp (defref CLOJURE_JARS)":"(defref VIMCLOJURE_JAR) 
          -server "vimclojure.nailgun.NGServer" @port 
          "<&- & 2&> /dev/null")

    (set! pid "$!")
    (echo @pid "> ${JARK_CONFIG_DIR}/vimclojure.pid")

    (sleep 2)
    (echo "")
    (echo "Loading dependencies ...")

    (if (and (file-exists? $(pwd)"/project.clj")  
             (directory? $(pwd)"/src")
             (directory? $(pwd)"/lib"))
      (@VIMCLOJURE ng-cp $(pwd)"/src" $(pwd)"/lib/*" "&> /dev/null"))

    $VIMCLOJURE ng-cp

    (echo "")
    (echo "Successfully started VimClojure server on port ${port}")
    (echo "")
    (echo "Connect with")
    (echo " :let vimclojure#WantNailgun = 1")
    (echo " :let vimclojure#NailgunPort = ${port}")
    (exit 0)

  ))


(def vim-module
  "The complete script for vim.sh"
  (with-script-context [:linux]
    (script
      (~start))))
