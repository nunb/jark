# Author: Ambrose Bonnaire-Sergeant
#
# Wishlist
# * remove jars from classpath
#
# TODO
# * list current VimClojure servers
# * "usage" function

DOC="Module to manage VimClojure instances"

. ${JARK_BIN}/shflags


VIMCLOJURE_JAR="${CLJR_CP}/server-2.2.0.jar"
OPEN_VMS="/tmp/vimclojure.open"

commands() {
    echo -e "start stop cp install"
}

_doc() {
    echo -e "jark vim start [--port -p (2443)]"
    echo -e "\tStart a local VimClojure server with minimum dependencies."
    echo -e "\tIf the current directory looks like a Leiningen project, try and add to the classpath."
    echo -e ""
    echo -e "jark vim stop [--host -o (127.0.0.1)] [--port -p (2443)]"
    echo -e "\tStop a VimClojure server."
    echo -e ""
    echo -e "jark vim cp [--host -o (127.0.0.1)] [--port -p (2443)] *args"
    echo -e "\tAdd to the classpath of an existing VimClojure server"
    echo -e ""
    echo -e "jark vim install"
    echo -e "\tInstall VimClojure dependencies."
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
    host="127.0.0.1"
    port=${FLAGS_port}

    # Make sure jar is installed
    if [ ! -e ${VIMCLOJURE_JAR} ]; then
        echo "FAILED VimClojure jar not installed"
        echo ""
        echo "Install instructions:"
        echo "  jark vim install"
        exit 1
    fi

    VIMCLOJURE="${CLJR_BIN}/ng --nailgun-server ${host} --nailgun-port ${port}"
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

    echo -e "${pid}\t${host}\t${port}" >> ${OPEN_VMS}
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
    DEFINE_string 'ho' '127.0.0.1' 'vimclojure host' 's'
    DEFINE_string 'po' '2443' 'vimclojure port' 'r'
    FLAGS "$@" || exit 1
    eval set -- "${FLAGS_ARGV}"
    host=${FLAGS_ho}
    port=${FLAGS_po}

    echo "Stopping VimClojure server at ${host}:${port} ..."
    echo ""

    VIMCLOJURE="${JARK_BIN}/ng --nailgun-server ${host} --nailgun-port ${port}"

    # Remove entry in open vms
    echo "host = ${host}"
    echo "port = ${port}"

    awk '!($2 == h && $3 == p)' h=$host p=$port ${OPEN_VMS} > ${OPEN_VMS}.tmp
    # for some reason redirecting directly didn't work... FIXME
    cp ${OPEN_VMS}.tmp ${OPEN_VMS}

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

    VIMCLOJURE="${JARK_BIN}/ng --nailgun-server ${host} --nailgun-port ${port}"

    # Add to cp
    if [ $@ ]; then
      $VIMCLOJURE ng-cp $@
    fi

    # Print cp
    echo "VimClojure classpath ($host:${port})"
    echo ""
    $VIMCLOJURE ng-cp
}


# Lists current known vimclojure servers
list() {
    echo -e "Pid\tHost\tPort"
    echo ""
    cat ${OPEN_VMS} | while read line; do
      echo $line | awk '{ print $1 "\t" $2 "\t" $3}'
    done
}
