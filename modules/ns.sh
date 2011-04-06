
commands() {
    echo -e "list find load run repl"
}

list() {
    if [ ! -n "${PAGER+x}" ]; then 
        $JARK _ns list $* 
    else
        $JARK _ns list $* | $PAGER
    fi
}

find() {
    $JARK_CLIENT ns find $* 
}

run() {
    $JARK_CLIENT ns run $* 
}

repl() {
    echo $* > /tmp/jark.ns
    which rlwrap &> /dev/null
    if [ $? == "0" ]; then
        rlwrap --break-chars "\"\\'(){}[],^%$#@;:|" \
          --remember \
          -m -q'"' -c \
          -f ${CLJR_BIN}/clj_completions \
          $JARK _ns repl $* 
    else
        $JARK _ns repl $* 
    fi
}

load() {
    f=$(readlink_f $1)
    if [ $f ]; then
        $JARK _ns load "$f"
        exit 0
    else
        echo "No such file: $1"
        exit 1
    fi
}

