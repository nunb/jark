
DOC="Module to manage the JVM server"

. ${JARK_BIN}/shflags

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
    echo -e "\tConnect to a remote JVM."
    echo -e ""
    echo -e "jark vm threads"
    echo -e "\tPrint a list of JVM threads."
    echo -e ""
    echo -e "jark vm uptime"
    echo -e "\tThe uptime of the current Jark server."
    echo -e ""
    echo -e "jark vm gc"
    echo -e "\tRun garbage collection on the current Jark server."
}

start() {
    DEFINE_string 'port' '9000' 'remote jark port' 'p'
    DEFINE_string 'jvm_opts' '-Xms64m -Xmx256m -DNOSECURITY=true' 'JVM Opts' 'o'
    FLAGS "$@" || exit 1
    eval set -- "${FLAGS_ARGV}"
    port=${FLAGS_port}

    rm -f ${JARK_CONFIG_DIR}/jark.client

    java ${FLAGS_jvm_opts} -cp ${JARK_CP}:${JARK_JAR} jark.vm $port <&- & 2&> /dev/null
    pid=$!
    echo ${pid} > ${JARK_CONFIG_DIR}/jark.pid
    echo ${port} > ${JARK_CONFIG_DIR}/jark.port
    echo "Started jark-nrepl server on port $port"

    sleep 5
    $JARK vm connect --port $port

    if [ -e $CLJR_CP/jark-deps.txt ]; then
        for dep in `cat $CLJR_CP/jark-deps.txt`; do
           $JARK cp add ${CLJR_ROOT}/$dep &> /dev/null
        done;
    fi
    if [ -e `pwd`/project.clj ] && [ -d `pwd`/src ] && [ -d `pwd`/lib ]; then
        $JARK cp add `pwd`/src 
        $JARK cp add `pwd`/lib
    fi
    echo "Added dependencies to classpath"
    
    sleep 2
    if [ -e $HOME/.jarkrc ]; then
        source $HOME/.jarkrc
    fi
    exit 0
}

stop() {
    if [ $(is_jark_running) == "no" ]; then
        echo "JVM server has already been stopped"
        exit 0
    fi
    echo "Stopping JVM server with pid `cat ${JARK_CONFIG_DIR}/jark.pid`"
    $JARK_CLIENT jark.vm stop
    rm -rf ${JARK_CONFIG_DIR}/jark.*
    exit 0
}

threads() {
    $JARK_CLIENT jark.vm threads | grep -v ^Thread | grep -v "pool-"
    exit 0
}

stat() {
    echo -e "Remote host \t `cat ${JARK_CONFIG_DIR}/jark.host`"
    echo -e "Port        \t `cat ${JARK_CONFIG_DIR}/jark.port`"
    $JARK_CLIENT jark.vm stats
    exit 0
}

stats() {
    $JARK_CLIENT jark.vm stats
    exit 0
}

gc() {
    $JARK_CLIENT jark.vm gc
    exit 0
}

uptime() {
    $JARK_CLIENT jark.vm uptime
    exit $?
}

connect() {
    DEFINE_string 'port' '9000' 'jark port' 'p'
    DEFINE_string 'host' 'localhost' 'jark host' 'r'

    FLAGS "$@" || exit 1
    eval set -- "${FLAGS_ARGV}"
    echo ${FLAGS_host} > ${JARK_CONFIG_DIR}/jark.host
    echo ${FLAGS_port} > ${JARK_CONFIG_DIR}/jark.port
    $JARK_CLIENT jark.vm uptime 2&> /dev/null
    if [ $? == "0" ]; then
        echo "Connected to ${FLAGS_host}:${FLAGS_port}"
    else
        echo "Failed connecting to ${FLAGS_host}:${FLAGS_port}"
    fi
    exit 0 
}
