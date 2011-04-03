# Author: Ambrose Bonnaire-Sergeant
#
# Wishlist
# * remove jars from classpath
#
# TODO
# * list current VimClojure servers
# * "usage" function

DOC="Module to manage VimClojure instances"

. ${CLJR_BIN}/shflags


VIMCLOJURE_JAR="${CLJR_CP}/server-2.2.0.jar"

commands() {
    echo -e "start stop cp install"
}

# Get vimclojure deps
install() {
    # Get vimclojure jar
    echo "Installing VimClojure dependencies ..."
    ${JARK} package install -p vimclojure/server -v 2.2.0
    echo ""
}

# Start a vimclojure server. If the pwd looks like
# a leiningen project, we add sources/libs to the classpath.
#
# Default port 2443, change with --port -p
start() {
    DEFINE_string 'port' '2443' 'vimclojure port' 'p'
    FLAGS "$@" || exit 1
    eval set -- "${FLAGS_ARGV}"
    port=${FLAGS_port}

    # Make sure jar is installed
    if [ ! -e ${VIMCLOJURE_JAR} ]; then
        echo "FAILED VimClojure jar not installed"
        echo ""
        echo "Install instructions:"
        echo "  jark vim install"
        exit 1
    fi

    VIMCLOJURE="${CLJR_BIN}/ng --nailgun-port ${port}"
    TESTPORT="${VIMCLOJURE} ng-cp"

    # TODO must be a better way of testing the port ...
    #   this will do for now. Something like TESTPORT = "yes" ? "no"
    # Also it seems stderr is not being ignored properly with
    # TESTPORT. I don't understand redirecting too well ...

    # Fail if port already responsive
    ${TESTPORT} &> /dev/null
    if [ $? -eq 0 ]; then
      echo "FAILED VimClojure server startup"
      echo "Port ${port} already in use by another Nailgun server"
      echo ""
      echo "To shut this server down:"
      echo "  jark vim stop --port ${port}"
      exit 1
    fi

    # Start up server
    echo "Starting VimClojure server on port ${port} ..."
    java -cp ${CLOJURE_JARS}:${VIMCLOJURE_JAR} -server vimclojure.nailgun.NGServer $port <&- & 2&> /dev/null
    pid=$!
    echo ${pid} > /tmp/vimclojure.pid

    sleep 2

    # Add stuff to cp
    ${TESTPORT} &> /dev/null
    if [ $? -eq 0 ]; then
      echo ""
      echo "Loading dependencies ..."
      if [ -e `pwd`/project.clj ] && [ -d `pwd`/src ] && [ -d `pwd`/lib ]; then
          ${VIMCLOJURE} ng-cp `pwd`/src `pwd`/lib/* &> /dev/null
      fi

      $VIMCLOJURE ng-cp

      echo ""
      echo "Successfully started VimClojure server on port ${port}"
      echo ""
      echo "Connect with"
      echo " :let vimclojure#WantNailgun = 1"
      echo " :let vimclojure#NailgunPort = ${port}"

      exit 0
    else
      echo ""
      echo "FAILED VimClojure server startup"
      echo "Port ${port} doesn't have a Nailgun server listening after attempted startup"

      exit 1
    fi
}

# Stop a vimclojure server.
#
# Change host with --host -o, default 127.0.0.1
# Default port 2443, change with --port -p
stop() {
    DEFINE_string 'host' '127.0.0.1' 'vimclojure host' 'o'
    DEFINE_string 'port' '2443' 'vimclojure port' 'p'
    FLAGS "$@" || exit 1
    eval set -- "${FLAGS_ARGV}"
    host=${FLAGS_host}
    port=${FLAGS_port}

    echo "Stopping VimClojure server at ${host}:${port} ..."
    echo ""

    VIMCLOJURE="${CLJR_BIN}/ng --nailgun-server ${host} --nailgun-port ${port}"

    $VIMCLOJURE ng-stop
}

# cp is listed for VimClojure server at port.
# Any arguments are added to the cp.
#
# Change host with --host -o, default 127.0.0.1
# Change port with --port -p, default 2443
cp() {
    DEFINE_string 'host' '127.0.0.1' 'vimclojure host' 'o'
    DEFINE_string 'port' '2443' 'vimclojure port' 'p'
    FLAGS "$@" || exit 1
    eval set -- "${FLAGS_ARGV}"
    host=${FLAGS_host}
    port=${FLAGS_port}

    VIMCLOJURE="${CLJR_BIN}/ng --nailgun-server ${host} --nailgun-port ${port}"

    # Add to cp
    if [ $@ ]; then
      $VIMCLOJURE ng-cp $@
    fi

    # Print cp
    echo "VimClojure classpath ($host:${port})"
    echo ""
    $VIMCLOJURE ng-cp
}
