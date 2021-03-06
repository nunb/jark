
commands() {
    echo -e "list find load run repl"
}

_doc() {
    echo -e "jark ns list (prefix)?"
    echo -e "\tList all namespaces in the classpath. Optionally takes a namespace prefix."
    echo -e ""
    echo -e "jark ns find prefix"
    echo -e "\tFind all namespaces starting with the given name"
    echo -e ""
    echo -e "jark ns load file"
    echo -e "\tLoads the given clj file, and adds relative classpath"
    echo -e ""
    echo -e "jark ns run main-ns args*"
    echo -e "\tRuns the given main function with args."
    echo -e ""
    echo -e "jark ns repl namespace"
    echo -e "\tLaunch a repl at given ns."
    echo -e ""
    echo -e "jark ns json <ns> <fn> (args+)"
    echo -e "\treturns output in json"
}

list() {
    if [ ! -n "${PAGER+x}" ]; then 
        $JARK_CLIENT jark.ns list $*
    else
        $JARK_CLIENT jark.ns list $* | $PAGER
    fi
    exit 0
}

find() {
    $JARK_CLIENT jark.ns find $*
    exit 0
}

run() {
    echo $1
    $JARK_CLIENT -- $1 -main
    exit 0
}

repl() {
    $JARK_CLIENT "(require 'jark.ns)"
    if [ "$?" == "1" ]; then
        echo "Unable to contact server, try reconnecting"
        exit 1
    fi
    echo $* > ${JARK_CONFIG_DIR}/jark.ns
    $JARK_CLIENT --repl $* 
    exit 0
}

load() {
    f=$(readlink_f "$1")
    if [ $f ]; then
        $(require cp)
        $(require ns)
        $JARK_CLIENT jark.ns load-clj "$f"
        exit 0
    else
        echo "No such file: $1"
        exit 1
    fi
}

json() {
    $JARK_CLIENT jark.ns cli-json $*
    exit 0
}

