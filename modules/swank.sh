
DOC="Module to manage jark itself"


. ${JARK_BIN}/shflags

commands() {
    echo -e "start stop"
}

_doc() {
    echo -e "jark swank start [--port -p (4005)] [--host -l (0.0.0.0)]"
    echo -e "\tStart a local swank server on the default port"
    echo -e ""
    echo -e "jark swank stop"
    echo -e "\tStop the local swank server on the default port."
}

start() {
    DEFINE_string 'port' '4005' 'swank port' 'p'
    DEFINE_string 'host' '0.0.0.0' 'address to listen on' 'l'
    FLAGS "$@" || exit 1
    eval set -- "${FLAGS_ARGV}"

    #FIXME
    echo ${FLAGS_port} > /tmp/swank.port
    $JARK_CLIENT jark.swank start ${FLAGS_host} ${FLAGS_port}
    if [ "$?" == "0" ]; then
        exit 0
    else
        echo "Failed to start swank server"
        exit 1
    fi
}

stop() {
    $JARK_CLIENT jark.swank stop
}

