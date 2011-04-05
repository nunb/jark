
DOC="Module to manage the JVM server"

. ${CLJR_BIN}/shflags

commands() {
    echo -e "start stop connect threads uptime gc"
}

start() {
    DEFINE_string 'port' '2113' 'remote jark port' 'p'
    DEFINE_string 'jvm_opts' '-Xms64m -Xmx256m' 'JVM Opts' 'o'
    FLAGS "$@" || exit 1
    eval set -- "${FLAGS_ARGV}"
    port=${FLAGS_port}

    rm -f /tmp/jark.client

    java ${FLAGS_jvm_opts} -cp ${JARK_CP}:${JARK_JAR} -server -main jark.core jark._vm start $port <&- & 2&> /dev/null 
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
    $JARK_CLIENT ng-stop
    rm -rf /tmp/jark.*
    exit 0
}

threads() {
    $JARK _stat threads
}

stat() {
    $JARK _stat stats
}

gc() {
    $JARK _stat gc
}

uptime() {
    $JARK _stat uptime
}

connect() {
    DEFINE_string 'port' '2113' 'remote jark port' 'p'
    DEFINE_string 'host' 'localhost' 'remote host' 'r'

    FLAGS "$@" || exit 1
    eval set -- "${FLAGS_ARGV}"

    cp /tmp/jark.client /tmp/jark.client.pre 2&> /dev/null
    echo "${CLJR_BIN}/ng --nailgun-server ${FLAGS_host} --nailgun-port ${FLAGS_port}" > /tmp/jark.client

    if [ $(is_jark_running) == "no" ]; then 
        echo "Failed to establish connection"
        mv /tmp/jark.client.pre /tmp/jark.client 2&> /dev/null
        exit 1
    else
        echo "Connection established successfully"
        exit 0
    fi
}
