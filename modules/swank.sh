
DOC="Module to manage jark itself"

commands() {
    echo -e "start stop"
}

start() {
    $JARK_CLIENT swank start
}

stop() {
    $JARK_CLIENT swank stop
}

