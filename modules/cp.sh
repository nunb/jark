
DOC="Classpath utilities"

commands() {
    echo -e "list add"
    exit 0
}

_doc() {
    echo -e "jark cp list"
    echo -e "\tList the classpath for the current Jark server."
    echo -e ""
    echo -e "jark cp add args+"
    echo -e "\tAdd to the classpath for the current Jark server."
    echo -e ""
    echo -e "jark cp run main-class"
    echo -e "\tRun main-class on the current Jark server."
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
            $JARK_CLIENT jark.cp add $i
        done
        $JARK_CLIENT jark.cp add $jar
        exit 0
    fi

    jp=$(readlink_f $jar)
    if [ $? == "0" ]; then
        $JARK_CLIENT jark.cp add $jar
        echo "Added $jar"
        exit 0
    else
        echo exiting
        exit 1
    fi
}

list() {
    $JARK_CLIENT jark.cp ls
    exit 0
}

ls() {
    list
    exit 0
}
