
DOC="Module to manage jark itself"


. ${JARK_BIN}/shflags

commands() {
    echo -e "start stop"
}

_doc() {
    echo -e "jark swank start [--port -p (4005)]"
    echo -e "\tStart a local swank server on the default port"
    echo -e ""
    echo -e "jark swank stop"
    echo -e "\tStop the local swank server on the default port."
}

start() {
    DEFINE_string 'port' '4005' 'swank port' 'p'
    FLAGS "$@" || exit 1
    eval set -- "${FLAGS_ARGV}"

    $JARK_CLIENT jark.swank start
    if [ "$?" == "0" ]; then
        echo "Started swank server on port ${FLAGS_port}"
        exit 0
    else
        echo "Failed to start swank server"
        exit 1
    fi
}

stop() {
    $JARK_CLIENT jark.swank stop
}

