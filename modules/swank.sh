
DOC="Module to manage jark itself"

commands() {
    echo -e "start stop"
}

_doc() {
    echo -e "jark swank start"
    echo -e "\tStart a local swank server on the default port"
    echo -e ""
    echo -e "jark swank stop"
    echo -e "\tStop the local swank server on the default port."
}

start() {
    $JARK_CLIENT jark.swank/start
    if [ "$?" == "0" ]; then
        echo "Started swank server on port 4005"
        exit 0
    else
        echo "Failed to start swank server"
        exit 1
    fi
}

stop() {
    $JARK_CLIENT jark.swank/stop
}

