
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
            echo "Adding $i .."
        done
        exit 0
    fi

    jp=$(readlink_f $jar)
    if [ $? == "0" ]; then
        echo "Adding $jp"
        exit 0
    else
        exit 1
    fi
}

list() {
    echo "Listing ..."
    exit 0
}

ls() {
    echo "Listing .."
    exit 0
}

run() {
    local mainclass="$1"
    touch classpath
    $JARK_CLIENT cm $mainclass
    exit 0
}
