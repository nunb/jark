
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
    $JARK_CLIENT swank start
}

stop() {
    $JARK_CLIENT swank stop
}

