
DOC="Module to manage the JVM server"

. ${CLJR_BIN}/shflags

commands() {
    echo -e "start stop connect threads uptime gc"
}

_doc() {
    echo -e "jark vm start [--port -p (9000)] [--jvm_opts o]"
    echo -e "\tStart a local Jark server. Takes optional JVM options as a \" delimited string."
    echo -e "\tTakes optional JVM options as a \" delimited string."
    echo -e ""
    echo -e "jark vm stop"
    echo -e "\tShuts down the current Jark server."
    echo -e ""
    echo -e "jark vm connect [--host -r (localhost)] [--port -p (9000)]"
    echo -e "\tConnect to a JVM."
    echo -e ""
    echo -e "jark vm threads"
    echo -e "\tPrint a summary of JVM threads."
    echo -e ""
    echo -e "jark vm uptime"
    echo -e "\tThe uptime of the current Jark server."
    echo -e ""
    echo -e "jark vm uptime gc"
    echo -e "\tAttempt to run some garbage collection on the current Jark server."
}

start() {
    DEFINE_string 'port' '9000' 'remote jark port' 'p'
    DEFINE_string 'jvm_opts' '-Xms64m -Xmx256m' 'JVM Opts' 'o'
    FLAGS "$@" || exit 1
    eval set -- "${FLAGS_ARGV}"
    port=${FLAGS_port}

    rm -f /tmp/jark.client

    java -cp ${JARK_CP}:${JARK_JAR} jark.vm <&- & 2&> /dev/null
    pid=$!
    echo ${pid} > /tmp/jark.pid
    echo ${port} > /tmp/jark.port

    sleep 2
    echo "Loading modules ..."
    $JARK &> /dev/null
    if [ -e $CLJR_CP/jark-deps.txt ]; then
        echo "Adding dependencies to classpath ..."
        for dep in `cat $CLJR_CP/jark-deps.txt`; do
           $JARK cp add ${CLJR_ROOT}/$dep &> /dev/null
        done;
    fi
    if [ -e `pwd`/project.clj ] && [ -d `pwd`/src ] && [ -d `pwd`/lib ]; then
        $JARK cp add `pwd`/src
        $JARK cp add `pwd`/lib
    fi
        
    if [ -e $HOME/.jarkrc ]; then
        source $HOME/.jarkrc
    fi
    echo "Started JVM server on port $port"
    exit 0
}

stop() {
    if [ $(is_jark_running) == "no" ]; then
        echo "JVM server has already been stopped"
        exit 0
    fi
    echo "Stopping JVM server with pid `cat /tmp/jark.pid`"
    $JARK_CLIENT vm stop
    rm -rf /tmp/jark.*
    exit 0
}

threads() {
    $JARK_CLIENT vm threads
}

stat() {
    $JARK_CLIENT vm stats
}

stats() {
    $JARK_CLIENT vm stats
}


gc() {
    $JARK_CLIENT vm gc
}

uptime() {
    $JARK_CLIENT vm uptime
    exit $?
}

connect() {
    DEFINE_string 'port' '9000' 'nrepl port' 'p'
    DEFINE_string 'host' 'localhost' 'nrepl host' 'r'

    FLAGS "$@" || exit 1
    eval set -- "${FLAGS_ARGV}"
    $JARK _nrepl connect ${FLAGS_host} ${FLAGS_port}
    exit 0 
}
