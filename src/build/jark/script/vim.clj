(ns build.jark.script.vim
  (:use [midje.sweet]
        [pallet.script :only [defscript defimpl with-script-context]]
        [pallet.script.lib :only [declare-arguments]]
        [pallet.stevedore :only [script do-script]]))

(defscript vim-module [])

(defimpl vim-module [:linux] []
  (~declare-arguments
     "Tools to manage VimClojure servers"
     [])

  (defn start 
    "Start a local VimClojure server with minimum dependencies"
    [port
     [:string host o "VimClojure host name" "localhost"]
     [:integer port p "VimClojure port" 2443]]

    (when (not (file-exists? @VIMCLOJURE_JAR))
      (echo "FAILED VimClojure jar not installed")
      (echo "")
      (echo "Install instructions:")
      (echo "  jark vim install")
      (exit 1))

    (echo "Starting VimClojure server on port ${port} ...")
    (java -cp "${CLOJURE_JARS}:${VIMCLOJURE_JAR}"
          -server "vimclojure.nailgun.NGServer" @port 
          "<&- & 2&> /dev/null")

    (set! pid "$!")
    (echo @pid "> ${JARK_CONFIG_DIR}/vimclojure.pid")

    (sleep 2)
    (echo "")
    (echo "Loading dependencies ...")

    (if (and (file-exists? "${pwd}/project.clj")  
             (directory? "${pwd}/src")
             (directory? "${pwd}/lib"))
      (@VIMCLOJURE ng-cp "${pwd}/src" "${pwd}/lib/*" "&> /dev/null"))

    $VIMCLOJURE ng-cp

    (echo "")
    (echo "Successfully started VimClojure server on port ${port}")
    (echo "")
    (echo "Connect with")
    (echo " :let vimclojure#WantNailgun = 1")
    (echo " :let vimclojure#NailgunPort = ${port}")
    (exit 0)
  )
)
