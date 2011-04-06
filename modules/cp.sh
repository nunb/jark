
DOC="Classpath utilities"

commands() {
    echo -e "list add run"
    exit 0
}

remove() {
     echo "command not implemented yet"
     exit 1
}

add() {
    local jar=$(readlink_f $1)
    if [ -z $jar ]; then
        echo "USAGE jark cp add <jarpath>"
        exit 0
    fi
    if [ -d $jar ]; then
        for i in `find ${jar} -name "*.jar" -print`
        do
            $JARK_CLIENT cp add $jar
        done
        $JARK_CLIENT cp list
        exit 0
    fi

    jp=$(readlink_f $jar)
    if [ $? == "0" ]; then
        $JARK_CLIENT cp add $jar
        $JARK_CLIENT cp list
        exit 0
    else
        exit 1
    fi
}

list() {
    $JARK_CLIENT cp ls
    exit 0
}

ls() {
    $JARK_CLIENT cp ls
    exit 0
}

run() {
    local mainclass="$1"
    touch classpath
    $JARK_CLIENT cm $mainclass
    exit 0
}
