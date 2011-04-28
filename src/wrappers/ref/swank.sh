
DOC="Module to manage jark itself"


. ${JARK_BIN}/shflags

commands() {
    echo -e "start stop"
}

_doc() {
    echo -e "jark swank start [--port -p (4005)] [--host -l (0.0.0.0)]"
    echo -e "\tStart a local swank server on the default port"
}

start() {
    DEFINE_string 'port' '4005' 'swank port' 'p'
    DEFINE_string 'host' '0.0.0.0' 'address to listen on' 'l'
    FLAGS "$@" || exit 1
    eval set -- "${FLAGS_ARGV}"

    $JARK_CLIENT jark.swank start ${FLAGS_host} ${FLAGS_port}
    if [ "$?" == "0" ]; then
        echo "Started swank server on ${FLAGS_host}:${FLAGS_port}"
        exit 0
    else
        echo "Failed to start swank server"
        exit 1
    fi
}

stop() {
    echo "Not implemented yet"
    exit 1
}

